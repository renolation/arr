import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_providers.dart';
import '../../../../core/network/models/jellyseerr_models.dart';

/// Provider for pending requests from Jellyseerr
class PendingRequestsNotifier extends AsyncNotifier<List<JellyseerrRequest>> {
  @override
  Future<List<JellyseerrRequest>> build() async {
    final api = await ref.watch(overseerrApiProvider.future);
    if (api == null) return [];

    final response = await api.getRequestList(
      filter: 'pending',
      sort: 'added',
      take: 50,
    );
    return response.results;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<JellyseerrRequest>>(
  PendingRequestsNotifier.new,
);

/// Provider for all requests (with filter support)
final requestFilterProvider = StateProvider<String?>((ref) => null);

class AllRequestsNotifier extends AsyncNotifier<List<JellyseerrRequest>> {
  @override
  Future<List<JellyseerrRequest>> build() async {
    final api = await ref.watch(overseerrApiProvider.future);
    final filter = ref.watch(requestFilterProvider);
    if (api == null) return [];

    final response = await api.getRequestList(
      filter: filter,
      sort: 'added',
      take: 50,
    );
    return response.results;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final allRequestsProvider =
    AsyncNotifierProvider<AllRequestsNotifier, List<JellyseerrRequest>>(
  AllRequestsNotifier.new,
);

/// Provider for trending content from Jellyseerr
final trendingProvider = FutureProvider<PagedResponse<JellyseerrMediaResult>>((ref) async {
  final api = await ref.watch(overseerrApiProvider.future);
  if (api == null) {
    return const PagedResponse(page: 1, totalPages: 0, totalResults: 0, results: []);
  }
  return await api.getTrending();
});

/// Notifier for request actions (approve, decline, create)
class RequestActionsNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> approve(int id) async {
    state = const AsyncLoading();
    try {
      final api = await ref.read(overseerrApiProvider.future);
      if (api == null) throw Exception('Overseerr not configured');
      await api.approveRequest(id);
      state = const AsyncData(null);
      // Refresh request lists
      ref.invalidate(pendingRequestsProvider);
      ref.invalidate(allRequestsProvider);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> decline(int id) async {
    state = const AsyncLoading();
    try {
      final api = await ref.read(overseerrApiProvider.future);
      if (api == null) throw Exception('Overseerr not configured');
      await api.declineRequest(id);
      state = const AsyncData(null);
      ref.invalidate(pendingRequestsProvider);
      ref.invalidate(allRequestsProvider);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> createRequest({
    required String mediaType,
    required int mediaId,
    List<int> seasons = const [],
    bool is4k = false,
  }) async {
    state = const AsyncLoading();
    try {
      final api = await ref.read(overseerrApiProvider.future);
      if (api == null) throw Exception('Overseerr not configured');
      await api.createRequest(
        mediaType: mediaType,
        mediaId: mediaId,
        seasons: seasons,
        is4k: is4k,
      );
      state = const AsyncData(null);
      ref.invalidate(pendingRequestsProvider);
      ref.invalidate(allRequestsProvider);
      ref.invalidate(trendingProvider);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

final requestActionsProvider =
    NotifierProvider<RequestActionsNotifier, AsyncValue<void>>(
  RequestActionsNotifier.new,
);

/// Whether Overseerr is configured
final isOverseerrConfiguredProvider = FutureProvider<bool>((ref) async {
  final api = await ref.watch(overseerrApiProvider.future);
  return api != null;
});
