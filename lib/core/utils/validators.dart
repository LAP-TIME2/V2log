/// 입력 검증 유틸리티
class Validators {
  Validators._();

  /// 이메일 검증
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식을 입력해주세요';
    }

    return null;
  }

  /// 비밀번호 검증
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (value.length < 8) {
      return '비밀번호는 8자 이상이어야 합니다';
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return '비밀번호에 영문자를 포함해주세요';
    }

    if (!RegExp(r'\d').hasMatch(value)) {
      return '비밀번호에 숫자를 포함해주세요';
    }

    return null;
  }

  /// 비밀번호 확인 검증
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '비밀번호 확인을 입력해주세요';
      }

      if (value != password) {
        return '비밀번호가 일치하지 않습니다';
      }

      return null;
    };
  }

  /// 닉네임 검증
  static String? nickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }

    if (value.length < 2) {
      return '닉네임은 2자 이상이어야 합니다';
    }

    if (value.length > 20) {
      return '닉네임은 20자 이하여야 합니다';
    }

    if (RegExp(r'[^\w가-힣]').hasMatch(value)) {
      return '닉네임은 한글, 영문, 숫자만 사용 가능합니다';
    }

    return null;
  }

  /// 필수 입력 검증
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName을(를) 입력해주세요' : '필수 입력 항목입니다';
    }
    return null;
  }

  /// 숫자 검증
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName을(를) 입력해주세요' : '숫자를 입력해주세요';
    }

    if (double.tryParse(value) == null) {
      return '올바른 숫자를 입력해주세요';
    }

    return null;
  }

  /// 양수 검증
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final num = double.parse(value!);
    if (num <= 0) {
      return '0보다 큰 숫자를 입력해주세요';
    }

    return null;
  }

  /// 범위 검증
  static String? Function(String?) range({
    required double min,
    required double max,
    String? fieldName,
  }) {
    return (String? value) {
      final numberError = number(value, fieldName: fieldName);
      if (numberError != null) return numberError;

      final num = double.parse(value!);
      if (num < min || num > max) {
        return '$min ~ $max 사이의 값을 입력해주세요';
      }

      return null;
    };
  }

  /// 최소 길이 검증
  static String? Function(String?) minLength(int length, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.length < length) {
        return fieldName != null
            ? '$fieldName은(는) $length자 이상이어야 합니다'
            : '$length자 이상 입력해주세요';
      }
      return null;
    };
  }

  /// 최대 길이 검증
  static String? Function(String?) maxLength(int length, {String? fieldName}) {
    return (String? value) {
      if (value != null && value.length > length) {
        return fieldName != null
            ? '$fieldName은(는) $length자 이하여야 합니다'
            : '$length자 이하로 입력해주세요';
      }
      return null;
    };
  }

  /// 무게 검증 (0.1 ~ 500kg)
  static String? weight(String? value) {
    return range(min: 0.1, max: 500, fieldName: '무게')(value);
  }

  /// 반복 횟수 검증 (1 ~ 100회)
  static String? reps(String? value) {
    final rangeError = range(min: 1, max: 100, fieldName: '반복 횟수')(value);
    if (rangeError != null) return rangeError;

    final num = double.parse(value!);
    if (num != num.roundToDouble()) {
      return '반복 횟수는 정수여야 합니다';
    }

    return null;
  }

  /// 신장 검증 (100 ~ 250cm)
  static String? height(String? value) {
    return range(min: 100, max: 250, fieldName: '신장')(value);
  }

  /// 체중 검증 (30 ~ 300kg)
  static String? bodyWeight(String? value) {
    return range(min: 30, max: 300, fieldName: '체중')(value);
  }
}
