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

/// Notifier for trending content with infinite scroll
class TrendingNotifier extends AsyncNotifier<List<JellyseerrMediaResult>> {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  bool get canLoadMore => _currentPage < _totalPages && !_isLoadingMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<JellyseerrMediaResult>> build() async {
    _currentPage = 1;
    _totalPages = 1;
    return _fetchPage(1);
  }

  Future<List<JellyseerrMediaResult>> _fetchPage(int page) async {
    final api = await ref.read(overseerrApiProvider.future);
    if (api == null) return [];
    final response = await api.getTrending(page: page);
    _totalPages = response.totalPages;
    _currentPage = response.page;
    return response.results;
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    final currentData = state.valueOrNull ?? [];
    _isLoadingMore = true;
    state = AsyncData(currentData); // keep current data visible
    try {
      final newResults = await _fetchPage(_currentPage + 1);
      _isLoadingMore = false;
      state = AsyncData([...currentData, ...newResults]);
    } catch (e) {
      _isLoadingMore = false;
      // Keep existing data on error
      state = AsyncData(currentData);
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _totalPages = 1;
    _isLoadingMore = false;
    ref.invalidateSelf();
  }
}

final trendingProvider =
    AsyncNotifierProvider<TrendingNotifier, List<JellyseerrMediaResult>>(
  TrendingNotifier.new,
);

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
    int? serverId,
    int? profileId,
    String? rootFolder,
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
        serverId: serverId,
        profileId: profileId,
        rootFolder: rootFolder,
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

/// Search query for Jellyseerr media search
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Search results from Jellyseerr
final searchResultsProvider = FutureProvider<PagedResponse<JellyseerrMediaResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) {
    return const PagedResponse(page: 1, totalPages: 0, totalResults: 0, results: []);
  }
  final api = await ref.watch(overseerrApiProvider.future);
  if (api == null) {
    return const PagedResponse(page: 1, totalPages: 0, totalResults: 0, results: []);
  }
  return await api.searchMedia(query);
});

/// Radarr servers configured in Jellyseerr
final radarrServersProvider = FutureProvider<List<JellyseerrServiceServer>>((ref) async {
  final api = await ref.watch(overseerrApiProvider.future);
  if (api == null) return [];
  return await api.getRadarrServers();
});

/// Sonarr servers configured in Jellyseerr
final sonarrServersProvider = FutureProvider<List<JellyseerrServiceServer>>((ref) async {
  final api = await ref.watch(overseerrApiProvider.future);
  if (api == null) return [];
  return await api.getSonarrServers();
});

/// Whether Overseerr is configured
final isOverseerrConfiguredProvider = FutureProvider<bool>((ref) async {
  final api = await ref.watch(overseerrApiProvider.future);
  return api != null;
});
