/// Base exception class for all app-specific exceptions
class AppException implements Exception {
  final String message;
  final String code;

  const AppException(this.message, {this.code = 'APP_ERROR'});

  @override
  String toString() => 'AppException: [$code] $message';
}

/// Database related exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code = 'DB_ERROR'});
}

/// Notification related exceptions
class NotificationException extends AppException {
  const NotificationException(super.message, {super.code = 'NOTIFICATION_ERROR'});
}

/// OCR processing exceptions
class OcrException extends AppException {
  const OcrException(super.message, {super.code = 'OCR_ERROR'});
}
