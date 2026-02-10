import '../entities/request.dart';

/// Repository interface for request operations
abstract class RequestsRepository {
  /// Get all requests
  Future<List<Request>> getAllRequests();

  /// Get pending requests
  Future<List<Request>> getPendingRequests();

  /// Get request by ID
  Future<Request> getRequestById(int id);

  /// Approve a request
  Future<Request> approveRequest(int id);

  /// Decline a request
  Future<Request> declineRequest(int id);

  /// Get cached requests
  Future<List<Request>> getCachedRequests();
}
