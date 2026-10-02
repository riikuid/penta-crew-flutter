import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Thin wrapper around `flutter_local_notifications`.
///
/// Independent of Firebase: usable on its own for in-app reminders, and used by
/// `FirebasePushService` to display foreground FCM messages (Android does not
/// show them by itself).
class LocalNotificationService {
  LocalNotificationService({
    required this._talker,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const channelId = 'default';
  static const channelName = 'General';
  static const channelDescription = 'General notifications';

  final Talker _talker;
  final FlutterLocalNotificationsPlugin _plugin;
  final _tapped = StreamController<Map<String, dynamic>>.broadcast();
  bool _initialized = false;

  /// Payload of the notification the user tapped (decoded from the JSON
  /// passed to [show]). Empty map when the notification had no payload.
  Stream<Map<String, dynamic>> get onTapped => _tapped.stream;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        // Permission is requested explicitly via [requestPermission].
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onResponse,
    );

    // Channel settings are frozen by Android after creation; change the id to
    // ship new defaults.
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            description: channelDescription,
            importance: Importance.high,
          ),
        );

    // App launched from a notification while terminated.
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      final response = launch?.notificationResponse;
      if (response != null) _onResponse(response);
    }
  }

  /// Returns whether notifications are allowed after prompting if needed.
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload == null ? null : jsonEncode(payload),
      );
    } catch (e, st) {
      _talker.handle(e, st, 'LocalNotificationService.show');
    }
  }

  Future<void> cancel(int id) => _plugin.cancel(id: id);

  Future<void> cancelAll() => _plugin.cancelAll();

  void _onResponse(NotificationResponse response) {
    final raw = response.payload;
    if (raw == null || raw.isEmpty) {
      _tapped.add(const {});
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      _tapped.add(
        decoded is Map ? Map<String, dynamic>.from(decoded) : {'payload': raw},
      );
    } catch (_) {
      _tapped.add({'payload': raw});
    }
  }
}
