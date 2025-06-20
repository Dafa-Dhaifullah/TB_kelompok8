String formatTimeAgo(DateTime? dateTime) {
  if (dateTime == null) return '';
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else {
    return '${difference.inDays} days ago';
  }
}
