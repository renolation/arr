import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/system_status_remote_datasource.dart';
import '../../data/repositories/system_status_repository.dart';
import '../../domain/entities/system_status.dart';

/// Provider for Dio client
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// Provider for remote data source
final systemStatusRemoteDataSourceProvider = Provider<SystemStatusRemoteDataSource>((ref) {
  return SystemStatusRemoteDataSource(
    dioClient: ref.watch(dioClientProvider),
  );
});

/// Provider for repository
final systemStatusRepositoryProvider = Provider<SystemStatusRepositoryImpl>((ref) {
  return SystemStatusRepositoryImpl(
    remoteDataSource: ref.watch(systemStatusRemoteDataSourceProvider),
  );
});

/// Provider for Sonarr status
final sonarrStatusProvider = FutureProvider<SystemStatus>((ref) async {
  try {
    return await ref.watch(systemStatusRepositoryProvider).getSonarrStatus();
  } on ServerException catch (e) {
    throw Exception('Failed to connect to Sonarr: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for Radarr status
final radarrStatusProvider = FutureProvider<SystemStatus>((ref) async {
  try {
    return await ref.watch(systemStatusRepositoryProvider).getRadarrStatus();
  } on ServerException catch (e) {
    throw Exception('Failed to connect to Radarr: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for Overseerr status
final overseerrStatusProvider = FutureProvider<SystemStatus>((ref) async {
  try {
    return await ref.watch(systemStatusRepositoryProvider).getOverseerrStatus();
  } on ServerException catch (e) {
    throw Exception('Failed to connect to Overseerr: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for all statuses
final allStatusesProvider = FutureProvider<Map<String, SystemStatus>>((ref) async {
  try {
    return await ref.watch(systemStatusRepositoryProvider).getAllStatuses();
  } on ServerException catch (e) {
    throw Exception('Failed to load statuses: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider to check if all services are online
final servicesOnlineProvider = Provider<bool>((ref) {
  final allStatuses = ref.watch(allStatusesProvider);
  return allStatuses.when(
    data: (statuses) => statuses.isNotEmpty,
    loading: () => false,
    error: (_, __) => false,
  );
});
