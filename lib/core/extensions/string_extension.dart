/// String 확장
extension StringExtension on String {
  /// 첫 글자 대문자
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 모든 단어 첫 글자 대문자
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// 이메일 유효성 검사
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// 비밀번호 유효성 검사 (최소 8자, 영문+숫자)
  bool get isValidPassword {
    if (length < 8) return false;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(this);
    final hasDigit = RegExp(r'\d').hasMatch(this);
    return hasLetter && hasDigit;
  }

  /// 숫자만 추출
  String get digitsOnly {
    return replaceAll(RegExp(r'[^\d]'), '');
  }

  /// 숫자인지 확인
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// null이거나 비어있는지 확인
  bool get isNullOrEmpty => isEmpty;

  /// null이 아니고 비어있지 않은지 확인
  bool get isNotNullOrEmpty => isNotEmpty;

  /// 특정 길이로 자르기 (말줄임표 추가)
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// 한글 초성 추출
  String get initials {
    const chosung = [
      'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
      'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
    ];

    final buffer = StringBuffer();
    for (final char in runes) {
      if (char >= 0xAC00 && char <= 0xD7A3) {
        final index = ((char - 0xAC00) / 588).floor();
        buffer.write(chosung[index]);
      } else {
        buffer.writeCharCode(char);
      }
    }
    return buffer.toString();
  }

  /// 시간 문자열 파싱 (MM:SS 형식)
  Duration? get toDuration {
    final parts = split(':');
    if (parts.length != 2) return null;

    final minutes = int.tryParse(parts[0]);
    final seconds = int.tryParse(parts[1]);

    if (minutes == null || seconds == null) return null;

    return Duration(minutes: minutes, seconds: seconds);
  }
}

/// Nullable String 확장
extension NullableStringExtension on String? {
  /// null이거나 비어있는지 확인
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// null이 아니고 비어있지 않은지 확인
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// null이면 기본값 반환
  String orDefault(String defaultValue) => this ?? defaultValue;
}
