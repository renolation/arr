import 'package:freezed_annotation/freezed_annotation.dart';

part 'request.freezed.dart';

enum RequestStatus { pending, approved, declined, available, processing }

@freezed
class Request with _$Request {
  const factory Request({
    required int id,
    required String mediaTitle,
    required String mediaType, // 'movie' or 'tv'
    required RequestStatus status,
    String? posterUrl,
    String? overview,
    int? requestUserId,
    String? requestUserName,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Map<String, dynamic>? mediaData,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'pending';
    final status = RequestStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == statusStr.toLowerCase(),
      orElse: () => RequestStatus.pending,
    );

    final media = json['media'] as Map<String, dynamic>?;

    return Request(
      id: json['id'] as int? ?? 0,
      mediaTitle: media?['title'] as String? ?? 'Unknown',
      mediaType: media?['mediaType'] as String? ?? 'movie',
      status: status,
      posterUrl: media?['posterPath'] as String?,
      overview: media?['overview'] as String?,
      requestUserId: json['requestedBy']?['id'] as int?,
      requestUserName: json['requestedBy']?['username'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      modifiedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      mediaData: media,
    );
  }

  const Request._();

  /// Check if request is pending approval
  bool get isPending => status == RequestStatus.pending;

  /// Check if request is approved
  bool get isApproved => status == RequestStatus.approved;

  /// Check if request is available
  bool get isAvailable => status == RequestStatus.available;

  /// Check if request is processing
  bool get isProcessing => status == RequestStatus.processing;

  /// Check if request is declined
  bool get isDeclined => status == RequestStatus.declined;

  /// Check if has poster
  bool get hasPoster => posterUrl != null && posterUrl!.isNotEmpty;

  /// Get display status text
  String get statusText => status.name.toUpperCase();
}
