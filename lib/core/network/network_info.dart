import 'dart:io';

/// Utility class to check network connectivity status
class NetworkInfo {
  /// Check if device has internet connection
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  /// Check if connection is on WiFi (iOS only)
  Future<bool> get isWiFi async {
    // Note: This would require connectivity_plus package
    // For now, returning true as a placeholder
    return true;
  }

  /// Check if connection is on mobile data (iOS only)
  Future<bool> get isMobileData async {
    // Note: This would require connectivity_plus package
    // For now, returning false as a placeholder
    return false;
  }
}
