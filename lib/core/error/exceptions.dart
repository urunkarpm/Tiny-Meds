import 'package:flutter/material.dart';

/// Custom exception types for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => code != null ? '$code: $message' : message;
}

/// Database operation exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

/// Notification service exceptions
class NotificationException extends AppException {
  const NotificationException(super.message, {super.code});
}

/// Permission denied exceptions
class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message, {super.code = 'PERMISSION_DENIED'});
}

/// Validation exceptions for form inputs
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
  });
}

/// OCR processing exceptions
class OcrException extends AppException {
  const OcrException(super.message, {super.code = 'OCR_ERROR'});
}
