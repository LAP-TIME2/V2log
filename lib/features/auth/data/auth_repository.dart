import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:v2log/shared/services/supabase_service.dart';

part 'auth_repository.g.dart';

/// Auth Repository Provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref);
}

/// 인증 저장소
class AuthRepository {
  final AuthRepositoryRef _ref;

  AuthRepository(this._ref);

  SupabaseService get _supabase => _ref.read(supabaseServiceProvider);

  /// 현재 사용자
  User? get currentUser => _supabase.currentUser;

  /// 현재 세션
  Session? get currentSession => _supabase.currentSession;

  /// 로그인 상태
  bool get isLoggedIn => _supabase.isLoggedIn;

  /// Auth 상태 스트림
  Stream<AuthState> get authStateChanges => _supabase.authStateChanges;

  /// 이메일 로그인
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.signInWithEmail(
        email: email,
        password: password,
      );
    } catch (_) {
      rethrow;
    }
  }

  /// 이메일 회원가입
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? nickname,
  }) async {
    try {
      return await _supabase.signUpWithEmail(
        email: email,
        password: password,
        data: nickname != null ? {'nickname': nickname} : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Google 로그인
  Future<bool> signInWithGoogle() async {
    try {
      return await _supabase.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  /// Apple 로그인
  Future<bool> signInWithApple() async {
    try {
      return await _supabase.signInWithApple();
    } catch (e) {
      rethrow;
    }
  }

  /// Kakao 로그인
  Future<bool> signInWithKakao() async {
    try {
      return await _supabase.signInWithKakao();
    } catch (e) {
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _supabase.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// 비밀번호 재설정 이메일
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  /// 비밀번호 변경
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      return await _supabase.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }
}
