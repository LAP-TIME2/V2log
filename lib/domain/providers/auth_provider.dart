import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_model.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/supabase_service.dart';

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
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.tokenRefreshed:
      case AuthChangeEvent.userUpdated:
        ref.invalidateSelf();
        break;
      case AuthChangeEvent.signedOut:
        state = const AsyncData(null);
        break;
      default:
        break;
    }
  }

  /// 사용자 프로필 조회
  Future<UserModel?> _fetchUserProfile(String userId) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      final response = await supabase
          .from(SupabaseTables.users)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
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

      // 2. Users 테이블에 프로필 생성
      final now = DateTime.now().toIso8601String();
      await supabase.from(SupabaseTables.users).insert({
        'id': response.user!.id,
        'email': email,
        'nickname': nickname,
        'created_at': now,
        'updated_at': now,
      });

      // 3. 프로필 조회
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
  final authState = ref.watch(authProvider);
  return authState.valueOrNull?.id;
}
