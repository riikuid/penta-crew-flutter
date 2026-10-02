import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Context-free toasts (usable from cubit listeners and from `app.dart`).
/// Requires `ToastificationWrapper` above `MaterialApp` — see `app.dart`.
abstract final class AppToast {
  static void success(String message) => _show(message, ToastificationType.success);
  static void error(String message) => _show(message, ToastificationType.error);
  static void info(String message) => _show(message, ToastificationType.info);
  static void warning(String message) => _show(message, ToastificationType.warning);

  static void _show(String message, ToastificationType type) {
    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      title: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
    );
  }
}
