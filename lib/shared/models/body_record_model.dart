import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_record_model.freezed.dart';
part 'body_record_model.g.dart';

/// 신체 기록 모델
@freezed
class BodyRecordModel with _$BodyRecordModel {
  const BodyRecordModel._();

  const factory BodyRecordModel({
    required String id,
    required String userId,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    double? skeletalMuscleMass,
    double? bmi,
    double? chest,
    double? waist,
    double? hip,
    double? thigh,
    double? arm,
    String? notes,
    String? photoUrl,
    required DateTime recordedAt,
    DateTime? createdAt,
  }) = _BodyRecordModel;

  factory BodyRecordModel.fromJson(Map<String, dynamic> json) =>
      _$BodyRecordModelFromJson(json);

  /// BMI 자동 계산 (키가 있는 경우)
  double? calculateBmi(double? heightCm) {
    if (weight == null || heightCm == null || heightCm == 0) return null;
    final heightM = heightCm / 100;
    return weight! / (heightM * heightM);
  }

  /// BMI 카테고리
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    if (bmiValue < 18.5) return '저체중';
    if (bmiValue < 23) return '정상';
    if (bmiValue < 25) return '과체중';
    if (bmiValue < 30) return '비만';
    return '고도비만';
  }
}
