import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_queue_model.freezed.dart';
part 'sync_queue_model.g.dart';

/// 동기화 대기열 작업 유형
enum SyncOperation {
  @JsonValue('insert')
  insert,
  @JsonValue('update')
  update,
  @JsonValue('delete')
  delete,
}

/// 동기화 대기열 항목 모델
@freezed
class SyncQueueItem with _$SyncQueueItem {
  const factory SyncQueueItem({
    required String id,
    required SyncOperation operation,
    required String table,
    required Map<String, dynamic> data,
    @Default(0) int retryCount,
    required DateTime createdAt,
    DateTime? lastAttemptAt,
    String? error,
  }) = _SyncQueueItem;

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) =>
      _$SyncQueueItemFromJson(json);
}

/// SyncQueueItem 확장 메서드
extension SyncQueueItemX on SyncQueueItem {
  /// 동기화 가능 여부 (재시도 횟수 3회 미만)
  bool get canSync => retryCount < 3;

  /// 다음 작업 생성 (재시도 카운트 증가)
  SyncQueueItem withRetry() {
    return copyWith(
      retryCount: retryCount + 1,
      lastAttemptAt: DateTime.now(),
    );
  }
}

/// 동기화 상태
enum SyncStatus {
  /// 대기 중 (오프라인 또는 처리할 작업 없음)
  idle,
  /// 동기화 중
  syncing,
  /// 동기화 완료
  completed,
  /// 동기화 실패
  error,
}

/// 네트워크 연결 상태
enum ConnectionStatus {
  /// 온라인
  online,
  /// 오프라인
  offline,
  /// 알 수 없음
  unknown,
}
