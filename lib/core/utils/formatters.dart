/// String and data formatting utilities
class Formatters {
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String shortDateFormat = 'MM/dd/yyyy';
  static const String dayMonthFormat = 'MMM dd';

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  /// Format date to readable string
  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${_monthNames[date.month - 1]} ${_twoDigits(date.day)}, ${date.year}';
  }

  /// Format time to readable string
  static String formatTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  /// Format date and time
  static String formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${formatDate(date)} ${formatTime(date)}';
  }

  /// Format short date
  static String formatShortDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${_twoDigits(date.month)}/${_twoDigits(date.day)}/${date.year}';
  }

  /// Format day and month only
  static String formatDayMonth(DateTime? date) {
    if (date == null) return 'N/A';
    return '${_monthNames[date.month - 1]} ${_twoDigits(date.day)}';
  }

  /// Format file size in bytes to readable string
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Format duration in seconds to readable string
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  /// Format number with commas
  static String formatNumber(int number) {
    final string = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < string.length; i++) {
      final pos = string.length - i;
      if (pos % 3 == 0 && pos != string.length) {
        buffer.write(',');
      }
      buffer.write(string[i]);
    }
    return buffer.toString();
  }

  /// Format percentage
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  /// Format quality label
  static String formatQuality(String quality) {
    return quality.replaceAll('_', ' ').split('-').map((part) {
      return part.split(' ').map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1);
      }).join(' ');
    }).join(' - ');
  }

  /// Format season and episode number
  static String formatSeasonEpisode(int seasonNumber, int episodeNumber) {
    return 'S${seasonNumber.toString().padLeft(2, '0')}E${episodeNumber.toString().padLeft(2, '0')}';
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  /// Helper to format two-digit numbers
  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
