import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_service.g.dart';

/// Supabase 서비스 Provider
@Riverpod(keepAlive: true)
SupabaseService supabaseService(SupabaseServiceRef ref) {
  return SupabaseService();
}

/// Supabase 클라이언트 Provider
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return ref.watch(supabaseServiceProvider).client;
}

/// Supabase 서비스
class SupabaseService {
  /// Supabase 클라이언트
  SupabaseClient get client => Supabase.instance.client;

  /// 현재 사용자
  User? get currentUser => client.auth.currentUser;

  /// 현재 세션
  Session? get currentSession => client.auth.currentSession;

  /// 로그인 상태
  bool get isLoggedIn => currentUser != null;

  /// Auth 상태 스트림
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ==================== Auth ====================

  /// 이메일 로그인
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// 이메일 회원가입
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  /// 소셜 로그인 (Google)
  Future<bool> signInWithGoogle() async {
    return await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.v2log://login-callback/',
    );
  }

  /// 소셜 로그인 (Apple)
  Future<bool> signInWithApple() async {
    return await client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.supabase.v2log://login-callback/',
    );
  }

  /// 소셜 로그인 (Kakao)
  Future<bool> signInWithKakao() async {
    return await client.auth.signInWithOAuth(
      OAuthProvider.kakao,
      redirectTo: 'io.supabase.v2log://login-callback/',
    );
  }

  /// 로그아웃
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// 비밀번호 재설정 이메일
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  /// 비밀번호 변경
  Future<UserResponse> updatePassword(String newPassword) async {
    return await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // ==================== Database ====================

  /// 테이블 쿼리
  SupabaseQueryBuilder from(String table) => client.from(table);

  /// RPC 호출
  Future<dynamic> rpc(String fn, {Map<String, dynamic>? params}) async {
    return await client.rpc(fn, params: params);
  }

  // ==================== Storage ====================

  /// 스토리지 버킷
  SupabaseStorageClient get storage => client.storage;

  /// 파일 업로드
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    String? contentType,
  }) async {
    await storage.from(bucket).uploadBinary(
      path,
      fileBytes,
      fileOptions: FileOptions(contentType: contentType),
    );

    return storage.from(bucket).getPublicUrl(path);
  }

  /// 파일 삭제
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    await storage.from(bucket).remove([path]);
  }

  /// 공개 URL 가져오기
  String getPublicUrl(String bucket, String path) {
    return storage.from(bucket).getPublicUrl(path);
  }
}

/// Supabase 테이블 이름
abstract class SupabaseTables {
  static const String users = 'users';
  static const String exercises = 'exercises';
  static const String presetRoutines = 'preset_routines';
  static const String presetRoutineExercises = 'preset_routine_exercises';
  static const String routines = 'routines';
  static const String routineExercises = 'routine_exercises';
  static const String workoutSessions = 'workout_sessions';
  static const String workoutSets = 'workout_sets';
  static const String exerciseRecords = 'exercise_records';
  static const String bodyRecords = 'body_records';
}

/// Supabase 스토리지 버킷
abstract class SupabaseBuckets {
  static const String avatars = 'avatars';
  static const String exerciseImages = 'exercise-images';
}
