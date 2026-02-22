import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:v2log/core/errors/app_exception.dart';
import 'package:v2log/shared/models/user_model.dart';
import 'package:v2log/shared/services/supabase_service.dart';

part 'user_repository.g.dart';

/// User Repository Provider
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(ref);
}

/// 사용자 저장소
class UserRepository {
  final UserRepositoryRef _ref;

  UserRepository(this._ref);

  SupabaseService get _supabase => _ref.read(supabaseServiceProvider);

  /// 현재 로그인된 사용자 정보 가져오기
  Future<UserModel?> getCurrentUser() async {
    final userId = _supabase.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _supabase
          .from(SupabaseTables.users)
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// 사용자 ID로 사용자 정보 가져오기
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.users)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      throw DatabaseException(
        '사용자 정보 가져오기 실패',
        originalError: e,
      );
    }
  }

  /// 사용자 프로필 업데이트
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.users)
          .update(user.toJson())
          .eq('id', user.id)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (_) {
      rethrow;
    }
  }

  /// 프로필 이미지 업로드
  Future<String> uploadProfileImage({
    required String userId,
    required Uint8List imageBytes,
    String? contentType,
  }) async {
    try {
      final path = '$userId/avatar.jpg';
      final url = await _supabase.uploadFile(
        bucket: SupabaseBuckets.avatars,
        path: path,
        fileBytes: imageBytes,
        contentType: contentType ?? 'image/jpeg',
      );

      // 사용자 프로필 이미지 URL 업데이트
      await _supabase
          .from(SupabaseTables.users)
          .update({'profile_image_url': url})
          .eq('id', userId);

      return url;
    } catch (e) {
      rethrow;
    }
  }

  /// 닉네임 중복 확인
  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.users)
          .select('id')
          .eq('nickname', nickname)
          .maybeSingle();

      return response == null;
    } catch (_) {
      rethrow;
    }
  }

  /// 온보딩 정보 저장
  Future<UserModel> saveOnboardingData({
    required String userId,
    required String nickname,
    Gender? gender,
    DateTime? birthDate,
    double? height,
    double? weight,
    required ExperienceLevel experienceLevel,
    required FitnessGoal fitnessGoal,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.users)
          .update({
            'nickname': nickname,
            'gender': gender?.value,
            'birth_date': birthDate?.toIso8601String(),
            'height': height,
            'weight': weight,
            'experience_level': experienceLevel.value,
            'fitness_goal': fitnessGoal.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
