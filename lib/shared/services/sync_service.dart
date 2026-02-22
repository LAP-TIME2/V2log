import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';

import 'package:v2log/shared/models/sync_queue_model.dart';
import 'supabase_service.dart';

part 'sync_service.g.dart';

/// Sync Service Provider
@Riverpod(keepAlive: true)
SyncService syncService(SyncServiceRef ref) {
  return SyncService(ref);
}

/// 동기화 서비스
class SyncService {
  final SyncServiceRef _ref;
  static const String _queueBox = 'sync_queue';
  static const _uuid = Uuid();

  SyncService(this._ref);

  SupabaseService get _supabase => _ref.read(supabaseServiceProvider);

  /// 동기화 큐 박스
  Future<Box> get _queue async {
    if (!Hive.isBoxOpen(_queueBox)) {
      return await Hive.openBox(_queueBox);
    }
    return Hive.box(_queueBox);
  }

  // ==================== 큐 관리 ====================

  /// 큐에 작업 추가
  Future<void> enqueue({
    required SyncOperation operation,
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final box = await _queue;
      final item = SyncQueueItem(
        id: _uuid.v4(),
        operation: operation,
        table: table,
        data: data,
        createdAt: DateTime.now(),
      );
      await box.put(item.id, item.toJson());
    } catch (_) {
      // Error logged silently
    }
  }

  /// 큐에서 모든 항목 가져오기
  Future<List<SyncQueueItem>> getQueue() async {
    try {
      final box = await _queue;
      final items = <SyncQueueItem>[];
      for (final key in box.keys) {
        final json = box.get(key);
        if (json != null) {
          try {
            items.add(SyncQueueItem.fromJson(Map<String, dynamic>.from(json)));
          } catch (_) {
            // Error logged silently
          }
        }
      }
      // 생성 시간 순 정렬
      items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return items;
    } catch (e) {
      return [];
    }
  }

  /// 큐 항목 삭제
  Future<void> dequeue(String itemId) async {
    try {
      final box = await _queue;
      await box.delete(itemId);
    } catch (_) {
      // Error logged silently
    }
  }

  /// 큐 비우기
  Future<void> clearQueue() async {
    try {
      final box = await _queue;
      await box.clear();
    } catch (_) {
      // Error logged silently
    }
  }

  /// 대기 중인 작업 수
  Future<int> get pendingCount async {
    final box = await _queue;
    return box.length;
  }

  // ==================== 동기화 ====================

  /// 동기화 실행
  Future<SyncResult> sync() async {
    final items = await getQueue();
    if (items.isEmpty) {
      return SyncResult(success: 0, failed: 0, total: 0);
    }

    int success = 0;
    int failed = 0;

    for (final item in items) {
      if (!item.canSync) {
        // 재시도 횟수 초과 항목은 삭제
        await dequeue(item.id);
        failed++;
        continue;
      }

      try {
        await _syncItem(item);
        await dequeue(item.id);
        success++;
      } catch (e) {
        // 재시도를 위해 업데이트
        final box = await _queue;
        await box.put(item.id, item.withRetry().toJson());
        failed++;
      }
    }

    return SyncResult(success: success, failed: failed, total: items.length);
  }

  /// 단일 항목 동기화
  Future<void> _syncItem(SyncQueueItem item) async {
    final table = _getTableName(item.table);
    final data = item.data;

    switch (item.operation) {
      case SyncOperation.insert:
        await _supabase.from(table).insert(data);
        break;
      case SyncOperation.update:
        final id = data['id'] as String?;
        if (id == null) throw Exception('Update requires id');
        await _supabase.from(table).update(data).eq('id', id);
        break;
      case SyncOperation.delete:
        final id = data['id'] as String?;
        if (id == null) throw Exception('Delete requires id');
        await _supabase.from(table).delete().eq('id', id);
        break;
    }
  }

  /// 테이블 이름 변환
  String _getTableName(String table) {
    switch (table) {
      case 'workout_sessions':
        return SupabaseTables.workoutSessions;
      case 'workout_sets':
        return SupabaseTables.workoutSets;
      case 'exercise_records':
        return SupabaseTables.exerciseRecords;
      case 'body_records':
        return SupabaseTables.bodyRecords;
      default:
        return table;
    }
  }

  // ==================== 네트워크 상태 ====================

  /// 현재 연결 상태 확인
  Future<ConnectionStatus> checkConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        return ConnectionStatus.offline;
      }
      return ConnectionStatus.online;
    } catch (_) {
      return ConnectionStatus.unknown;
    }
  }

  /// 연결 상태 스트림
  Stream<ConnectionStatus> get connectionStream {
    return Connectivity()
        .onConnectivityChanged
        .map((results) {
          if (results.contains(ConnectivityResult.none)) {
            return ConnectionStatus.offline;
          }
          return ConnectionStatus.online;
        });
  }
}

/// 동기화 결과
class SyncResult {
  final int success;
  final int failed;
  final int total;

  SyncResult({
    required this.success,
    required this.failed,
    required this.total,
  });

  bool get hasFailure => failed > 0;
  bool get isComplete => success + failed >= total;
}
