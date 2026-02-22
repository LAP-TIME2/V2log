import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:v2log/shared/models/sync_queue_model.dart';
import 'package:v2log/shared/services/sync_service.dart';

part 'sync_provider.g.dart';

/// 연결 상태 Provider
@riverpod
class ConnectionState extends _$ConnectionState {
  StreamSubscription<ConnectionStatus>? _subscription;
  Timer? _syncTimer;

  @override
  ConnectionStatus build() {
    // 초기 상태 확인
    _checkInitialConnection();
    // 연결 상태 감시 시작
    _startWatching();
    // 주기적 동기화 (30초마다)
    _startPeriodicSync();

    ref.onDispose(() {
      _subscription?.cancel();
      _syncTimer?.cancel();
    });

    return ConnectionStatus.unknown;
  }

  Future<void> _checkInitialConnection() async {
    final syncService = ref.read(syncServiceProvider);
    final status = await syncService.checkConnection();
    state = status;
  }

  void _startWatching() {
    final syncService = ref.read(syncServiceProvider);
    _subscription = syncService.connectionStream.listen((status) {
      final wasOffline = state == ConnectionStatus.offline;
      state = status;

      // 오프라인 → 온라인 전환 시 자동 동기화
      if (wasOffline && status == ConnectionStatus.online) {
        ref.read(syncControllerProvider.notifier).syncNow();
      }
    });
  }

  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state == ConnectionStatus.online) {
        ref.read(syncControllerProvider.notifier).syncNow();
      }
    });
  }
}

/// 동기화 상태 Provider
@riverpod
class SyncState extends _$SyncState {
  @override
  SyncStatus build() => SyncStatus.idle;
}

/// 대기 중인 작업 수 Provider
@riverpod
Future<int> pendingSyncCount(PendingSyncCountRef ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return await syncService.pendingCount;
}

/// 동기화 컨트롤러 Provider
@riverpod
class SyncController extends _$SyncController {
  @override
  void build() {}

  /// 즉시 동기화 실행
  Future<void> syncNow() async {
    final connectionState = ref.read(connectionStateProvider);
    if (connectionState != ConnectionStatus.online) {
      return;
    }

    ref.read(syncStateProvider.notifier).state = SyncStatus.syncing;

    try {
      final syncService = ref.read(syncServiceProvider);
      final result = await syncService.sync();

      if (result.hasFailure) {
        ref.read(syncStateProvider.notifier).state = SyncStatus.error;
      } else if (result.total > 0) {
        ref.read(syncStateProvider.notifier).state = SyncStatus.completed;
        // 2초后 idle 상태로 복귀
        Future.delayed(const Duration(seconds: 2), () {
          ref.read(syncStateProvider.notifier).state = SyncStatus.idle;
        });
      } else {
        ref.read(syncStateProvider.notifier).state = SyncStatus.idle;
      }

      // pendingCount 갱신을 위해 invalidate
      ref.invalidate(pendingSyncCountProvider);
    } catch (_) {
      ref.read(syncStateProvider.notifier).state = SyncStatus.error;
      Future.delayed(const Duration(seconds: 2), () {
        ref.read(syncStateProvider.notifier).state = SyncStatus.idle;
      });
    }
  }

  /// 수동 연결 상태 갱신
  Future<void> refreshConnection() async {
    final syncService = ref.read(syncServiceProvider);
    final status = await syncService.checkConnection();
    ref.read(connectionStateProvider.notifier).state = status;

    // 온라인이면 동기화 시도
    if (status == ConnectionStatus.online) {
      await syncNow();
    }
  }
}

/// 동기화 상태 요약 Provider
@riverpod
SyncSummary syncSummary(SyncSummaryRef ref) {
  final connection = ref.watch(connectionStateProvider);
  final syncStatus = ref.watch(syncStateProvider);
  final pendingCountAsync = ref.watch(pendingSyncCountProvider);

  return SyncSummary(
    connection: connection,
    syncStatus: syncStatus,
    pendingCount: pendingCountAsync.value ?? 0,
  );
}

/// 동기화 상태 요약
class SyncSummary {
  final ConnectionStatus connection;
  final SyncStatus syncStatus;
  final int pendingCount;

  SyncSummary({
    required this.connection,
    required this.syncStatus,
    required this.pendingCount,
  });

  bool get isOnline => connection == ConnectionStatus.online;
  bool get isOffline => connection == ConnectionStatus.offline;
  bool get isSyncing => syncStatus == SyncStatus.syncing;
  bool get hasPending => pendingCount > 0;
}
