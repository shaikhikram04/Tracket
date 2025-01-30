class NotificationResult {
  final bool success;
  final String? error;

  const NotificationResult({
    required this.success,
    this.error,
  });

  static NotificationResult successful() => NotificationResult(success: true);
  static NotificationResult failure(String error) => 
      NotificationResult(success: false, error: error);
}