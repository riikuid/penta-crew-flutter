/// Push notification capability as seen by the rest of the app.
///
/// Core code and features depend only on this interface. The Firebase
/// implementation lives in `lib/integrations/firebase/` — the only folder
/// allowed to import `firebase_*` — and is wired in `locator.dart`. Without it,
/// [NoopPushService] keeps every call site working.
abstract interface class PushService {
  Future<void> init();

  /// Ask the OS for permission; returns whether notifications are allowed.
  Future<bool> requestPermission();

  /// Device token to send to the backend, or null when unavailable.
  Future<String?> getToken();

  Future<void> deleteToken();

  /// Foreground messages, already normalized.
  Stream<PushMessage> get onMessage;

  /// User tapped a notification (from background or terminated).
  Stream<PushMessage> get onMessageOpened;

  /// The provider rotated the device token; re-send it to the backend.
  Stream<String> get onTokenRefresh;
}

class PushMessage {
  const PushMessage({this.title, this.body, this.data = const {}});

  final String? title;
  final String? body;
  final Map<String, dynamic> data;
}
