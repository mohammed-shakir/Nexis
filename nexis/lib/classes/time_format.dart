class TimeFormat {
  static String formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formattedTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (timestamp.isAfter(today)) {
      return 'Today at ${formatTime(timestamp)}';
    } else if (timestamp.isAfter(yesterday)) {
      return 'Yesterday at ${formatTime(timestamp)}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${formatTime(timestamp)}';
    }
  }
}
