import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _prefKey = 'quick_record_notification_enabled';
  static const int _notificationId = 1001;
  static const String _channelId = 'penny_quick_record_channel';
  static const String _channelName = 'Penny Quick Record Notification';
  static const String _channelDesc =
      'Persistent notification for recording expenses quickly from device notification area';

  static ValueNotifier<bool> openAddSheetNotifier = ValueNotifier<bool>(false);

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == 'quick_record' ||
            response.actionId == 'action_record') {
          openAddSheetNotifier.value = true;
        }
      },
    );
  }

  static Future<bool> requestPermission() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      final granted = await androidImplementation
          .requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? true; // Enabled by default on onboarding
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);

    if (enabled) {
      final hasPermission = await requestPermission();
      if (hasPermission) {
        await showNotification();
      }
    } else {
      await cancelNotification();
    }
  }

  static Future<void> syncNotificationOnAppLaunch() async {
    final enabled = await isEnabled();
    if (enabled) {
      await requestPermission();
      await showNotification();
    } else {
      await cancelNotification();
    }
  }

  static Future<void> showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true, // Fixed / sticky in notification area
      autoCancel: false,
      showWhen: false,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'action_record',
          '+ Record Expense',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: _notificationId,
      title: 'Penny - Quick Financial Record',
      body: 'Tap here or "+ Record Expense" to log expenditure instantly.',
      notificationDetails: notificationDetails,
      payload: 'quick_record',
    );
  }

  static Future<void> cancelNotification() async {
    await _notificationsPlugin.cancel(id: _notificationId);
  }
}
