import '../../../../core/errors/exceptions.dart';
import '../entities/system_status.dart';

/// Repository interface for system status operations
abstract class SystemStatusRepository {
  /// Get Sonarr system status
  Future<SystemStatus> getSonarrStatus();

  /// Get Radarr system status
  Future<SystemStatus> getRadarrStatus();

  /// Get Overseerr system status
  Future<SystemStatus> getOverseerrStatus();

  /// Get all service statuses
  Future<Map<String, SystemStatus>> getAllStatuses();
}
