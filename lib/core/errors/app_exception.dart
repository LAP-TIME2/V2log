/// V2log 앱 통합 예외 타입
///
/// 모든 Repository에서 이 타입으로 래핑하여 throw.
/// Provider에서는 AsyncValue.guard()로 자동 캐치.
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final Object? originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => '$runtimeType: $message${code != null ? ' ($code)' : ''}';
}

/// 네트워크/연결 에러
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});
}

/// 인증 에러 (로그인 실패, 토큰 만료 등)
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalError});
}

/// 데이터베이스 에러 (Supabase 쿼리 실패, 제약조건 위반 등)
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.originalError});
}

/// 입력값 검증 에러
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.originalError});
}

/// 리소스를 찾을 수 없음 (404)
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.originalError});
}
