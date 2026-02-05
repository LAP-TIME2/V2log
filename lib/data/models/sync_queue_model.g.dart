// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncQueueItemImpl _$$SyncQueueItemImplFromJson(Map<String, dynamic> json) =>
    _$SyncQueueItemImpl(
      id: json['id'] as String,
      operation: $enumDecode(_$SyncOperationEnumMap, json['operation']),
      table: json['table'] as String,
      data: json['data'] as Map<String, dynamic>,
      retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastAttemptAt: json['last_attempt_at'] == null
          ? null
          : DateTime.parse(json['last_attempt_at'] as String),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$SyncQueueItemImplToJson(_$SyncQueueItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'operation': _$SyncOperationEnumMap[instance.operation]!,
      'table': instance.table,
      'data': instance.data,
      'retry_count': instance.retryCount,
      'created_at': instance.createdAt.toIso8601String(),
      'last_attempt_at': instance.lastAttemptAt?.toIso8601String(),
      'error': instance.error,
    };

const _$SyncOperationEnumMap = {
  SyncOperation.insert: 'insert',
  SyncOperation.update: 'update',
  SyncOperation.delete: 'delete',
};
