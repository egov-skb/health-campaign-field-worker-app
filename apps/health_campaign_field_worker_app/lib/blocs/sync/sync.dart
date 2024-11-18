// GENERATED using mason_cli
import 'dart:async';

import 'package:digit_data_model/data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

import '../../data/network_manager.dart';
import '../../models/bandwidth/bandwidth_model.dart';
import '../../utils/utils.dart';

part 'sync.freezed.dart';

typedef SyncEmitter = Emitter<SyncState>;

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final Isar isar;
  final NetworkManager networkManager;

  SyncBloc({
    required this.isar,
    required this.networkManager,
  }) : super(const SyncPendingState()) {
    on(_handleRefresh);
    on(_handleSyncUp);
  }

  FutureOr<void> _handleRefresh(
    SyncRefreshEvent event,
    SyncEmitter emit,
  ) async {
    final previousCount = state.maybeWhen(
      pendingSync: (count) => count,
      orElse: () => 0,
    );

    int? length = event.count;
    emit(const SyncState.loading());
    try {
      length ??= getSyncCount(isar.opLogs
              .filter()
              .createdByEqualTo(event.createdBy)
              .syncedUpEqualTo(false)
              .findAllSync()) +
          getSyncCount(isar.opLogs
              .filter()
              .createdByEqualTo(event.createdBy)
              .syncedUpEqualTo(true)
              .syncedDownEqualTo(false)
              .findAllSync());
    } catch (_) {
      rethrow;
    } finally {
      emit(SyncPendingState(count: length ?? previousCount));
    }
  }

  FutureOr<void> _handleSyncUp(
    SyncSyncUpEvent event,
    SyncEmitter emit,
  ) async {
    try {
      final BandwidthModel bandwidthModel = BandwidthModel.fromJson({
        'userId': event.userId,
        'batchSize': 5,
      });
      emit(const SyncInProgressState());

      await networkManager.performSync(
        localRepositories: event.localRepositories,
        remoteRepositories: event.remoteRepositories,
        bandwidthModel: bandwidthModel,
      );
      emit(const SyncCompletedState());
    } on SyncError catch (error) {
      if (error is SyncDownError) {
        emit(const DownSyncFailedState());
      } else {
        emit(const UpSyncFailedState());
      }

      rethrow;
    } catch (error) {
      emit(const SyncFailedState());
      rethrow;
    } finally {
      add(SyncRefreshEvent(event.userId));
    }
  }
}

@freezed
class SyncEvent with _$SyncEvent {
  const factory SyncEvent.refresh(String createdBy, [int? count]) =
      SyncRefreshEvent;

  const factory SyncEvent.syncUp({
    required String userId,
    required List<LocalRepository> localRepositories,
    required List<RemoteRepository> remoteRepositories,
  }) = SyncSyncUpEvent;
}

@freezed
class SyncState with _$SyncState {
  const factory SyncState.loading() = SyncLoadingState;

  const factory SyncState.syncInProgress() = SyncInProgressState;

  const factory SyncState.pendingSync({@Default(0) int count}) =
      SyncPendingState;

  const factory SyncState.completedSync() = SyncCompletedState;

  const factory SyncState.failedSync() = SyncFailedState;

  const factory SyncState.failedDownSync() = DownSyncFailedState;

  const factory SyncState.failedUpSync() = UpSyncFailedState;
}
