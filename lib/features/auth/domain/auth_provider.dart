import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:v2log/shared/models/user_model.dart';
import 'package:v2log/shared/services/local_storage_service.dart';
import 'package:v2log/shared/services/supabase_service.dart';

part 'auth_provider.g.dart';

/// 현재 인증 상태 Provider
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  FutureOr<UserModel?> build() async {
    // Auth 상태 변경 구독
    _authSubscription?.cancel();
    _authSubscription = ref
        .watch(supabaseServiceProvider)
        .authStateChanges
        .listen(_onAuthStateChange);

    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    // 현재 세션 확인
    final supabase = ref.watch(supabaseServiceProvider);
    if (!supabase.isLoggedIn) return null;

    return await _fetchUserProfile(supabase.currentUser!.id);
  }

  void _onAuthStateChange(AuthState authState) {
    final event = authState.event;

    switch (event) {
      case AuthChangeEvent.signedOut:
        // 로그아웃 시에만 상태 초기화
        state = const AsyncData(null);
        break;
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.tokenRefreshed:
      case AuthChangeEvent.userUpdated:
      case AuthChangeEvent.initialSession:
        // 이미 프로필이 로드되어 있으면 무시 (무한 루프 방지)
        // build()에서 이미 프로필을 로드하므로 여기서는 처리하지 않음
        break;
      default:
        break;
    }
  }

  /// 사용자 프로필 조회 (없으면 자동 생성)
  Future<UserModel?> _fetchUserProfile(String userId) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      final response = await supabase
          .from(SupabaseTables.users)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {

        // Supabase Auth에서 현재 사용자 정보 가져오기
        final authUser = supabase.currentUser;
        if (authUser == null) {
          return null;
        }

        // users 테이블에 레코드 생성
        final now = DateTime.now().toIso8601String();
        final email = authUser.email ?? '';
        final nickname = authUser.userMetadata?['nickname'] as String? ??
                        authUser.userMetadata?['name'] as String? ??
                        email.split('@').first;

        await supabase.from(SupabaseTables.users).insert({
          'id': userId,
          'email': email,
          'nickname': nickname,
          'fitness_goal': 'HYPERTROPHY',
          'preferred_mode': 'HYBRID',
          'experience_level': 'BEGINNER',
          'created_at': now,
          'updated_at': now,
        });

        // 다시 조회
        final newResponse = await supabase
            .from(SupabaseTables.users)
            .select()
            .eq('id', userId)
            .maybeSingle();

        if (newResponse == null) {
          return null;
        }

        final user = UserModel.fromJson(newResponse);
        return user;
      }
      final user = UserModel.fromJson(response);
      return user;
    } catch (_) {
      return null;
    }
  }

  /// 이메일 로그인
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final supabase = ref.read(supabaseServiceProvider);
      final response = await supabase.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('로그인에 실패했습니다');
      }

      // 로컬 저장소에 사용자 ID 저장
      ref.read(localStorageServiceProvider).lastUserId = response.user!.id;

      return await _fetchUserProfile(response.user!.id);
    });
  }

  /// 이메일 회원가입
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String nickname,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final supabase = ref.read(supabaseServiceProvider);

      // 1. Auth 회원가입
      final response = await supabase.signUpWithEmail(
        email: email,
        password: password,
        data: {'nickname': nickname},
      );

      if (response.user == null) {
        throw Exception('회원가입에 실패했습니다');
      }

      // 2. Users 테이블에 프로필 생성 (실패해도 Auth 가입은 유지)
      try {
        final now = DateTime.now().toIso8601String();
        await supabase.from(SupabaseTables.users).insert({
          'id': response.user!.id,
          'email': email,
          'nickname': nickname,
          'fitness_goal': 'HYPERTROPHY',
          'preferred_mode': 'HYBRID',
          'experience_level': 'BEGINNER',
          'created_at': now,
          'updated_at': now,
        });
      } catch (e) {
        // INSERT 실패 시 로그만 남기고 계속 진행
      }

      // 3. 로컬 저장소에 사용자 ID 저장
      ref.read(localStorageServiceProvider).lastUserId = response.user!.id;

      // 4. 프로필 조회
      return await _fetchUserProfile(response.user!.id);
    });
  }

  /// Google 로그인
  Future<void> signInWithGoogle() async {
    final supabase = ref.read(supabaseServiceProvider);
    await supabase.signInWithGoogle();
  }

  /// Apple 로그인
  Future<void> signInWithApple() async {
    final supabase = ref.read(supabaseServiceProvider);
    await supabase.signInWithApple();
  }

  /// Kakao 로그인
  Future<void> signInWithKakao() async {
    final supabase = ref.read(supabaseServiceProvider);
    await supabase.signInWithKakao();
  }

  /// 로그아웃
  Future<void> signOut() async {
    final supabase = ref.read(supabaseServiceProvider);
    final localStorage = ref.read(localStorageServiceProvider);

    await supabase.signOut();
    await localStorage.clearUserData();

    state = const AsyncData(null);
  }

  /// 비밀번호 재설정
  Future<void> resetPassword(String email) async {
    final supabase = ref.read(supabaseServiceProvider);
    await supabase.resetPassword(email);
  }

  /// 사용자 프로필 새로고침
  Future<void> refresh() async {
    final supabase = ref.read(supabaseServiceProvider);
    if (!supabase.isLoggedIn) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await _fetchUserProfile(supabase.currentUser!.id);
    });
  }
}

/// 로그인 상태 Provider
@riverpod
bool isLoggedIn(IsLoggedInRef ref) {
  final authState = ref.watch(authProvider);
  return authState.valueOrNull != null;
}

/// 현재 사용자 ID Provider
@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  // 먼저 authProvider에서 확인
  final authState = ref.watch(authProvider);
  final userModelId = authState.valueOrNull?.id;
  if (userModelId != null) return userModelId;

  // authProvider가 null이면 Supabase Auth 세션에서 직접 확인
  final supabase = ref.watch(supabaseServiceProvider);
  return supabase.currentUser?.id;
}
