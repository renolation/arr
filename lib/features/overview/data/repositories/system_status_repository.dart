import '../../../../core/errors/exceptions.dart';
import '../datasources/system_status_remote_datasource.dart';
import '../../domain/entities/system_status.dart';
import '../../domain/repositories/system_status_repository.dart';

/// Repository implementation for system status
class SystemStatusRepositoryImpl implements SystemStatusRepository {
  final SystemStatusRemoteDataSource remoteDataSource;

  SystemStatusRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SystemStatus> getSonarrStatus() async {
    try {
      final statusData = await remoteDataSource.getSonarrSystemStatus();
      final status = SystemStatus.fromJson(statusData);
      return status;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get Sonarr status: ${e.toString()}');
    }
  }

  @override
  Future<SystemStatus> getRadarrStatus() async {
    try {
      final statusData = await remoteDataSource.getRadarrSystemStatus();
      final status = SystemStatus.fromJson(statusData);
      return status;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get Radarr status: ${e.toString()}');
    }
  }

  @override
  Future<SystemStatus> getOverseerrStatus() async {
    try {
      final statusData = await remoteDataSource.getOverseerrSystemStatus();
      final status = SystemStatus.fromJson(statusData);
      return status;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get Overseerr status: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, SystemStatus>> getAllStatuses() async {
    try {
      final results = await Future.wait([
        remoteDataSource.getSonarrSystemStatus(),
        remoteDataSource.getRadarrSystemStatus(),
        remoteDataSource.getOverseerrSystemStatus(),
      ]);

      final statuses = {
        'sonarr': SystemStatus.fromJson(results[0]),
        'radarr': SystemStatus.fromJson(results[1]),
        'overseerr': SystemStatus.fromJson(results[2]),
      };

      return statuses;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get all statuses: ${e.toString()}');
    }
  }
}
