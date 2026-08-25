import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shopping_app/src/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.saveRemoteMessage(message);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _storageKey = 'saved_notifications';
  static final ValueNotifier<List<NotificationModel>> notificationsNotifier =
      ValueNotifier<List<NotificationModel>>([]);

  static Future<void> initialize() async {
    await _loadNotifications();

    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(alert: true, badge: true, sound: true);

      String? token = await messaging.getToken();
      debugPrint("FCM Token: $token");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          _addNotification(
            NotificationModel(
              id:
                  message.messageId ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              title: message.notification?.title ?? 'Notification',
              subtitle: message.notification?.body ?? '',
              timestamp: DateTime.now(),
              iconType: 'default',
              payload: message.data.toString(),
            ),
          );

          // Show local notification
          showLocalNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: message.data.toString(),
          );
        }
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      debugPrint("FCM initialized successfully");
    } catch (e) {
      debugPrint("FCM initialization error: $e");
    }

    try {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      // Initialize OneSignal with App ID
      OneSignal.initialize("b330696b-1671-496c-ba0a-799cf9ec8d78");

      // Request permission
      OneSignal.Notifications.requestPermission(true);

      // Log Subscription Status for debugging
      final id = OneSignal.User.pushSubscription.id;
      final token = OneSignal.User.pushSubscription.token;
      debugPrint("OneSignal: Subscription ID: $id");
      debugPrint("OneSignal: Push Token: $token");

      // Handle foreground notifications
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        debugPrint(
          'OneSignal: Foreground notification: ${event.notification.title}',
        );

        final notif = NotificationModel(
          id: event.notification.notificationId,
          title: event.notification.title ?? 'Notification',
          subtitle: event.notification.body ?? '',
          timestamp: DateTime.now(),
          iconType: 'default',
          payload: event.notification.additionalData?.toString(),
        );

        // Add to list, save to storage, and notify listeners
        _addNotification(notif);

        // Display the notification alert
        event.notification.display();
      });

      // Handle notification clicks
      OneSignal.Notifications.addClickListener((event) {
        debugPrint(
          'OneSignal: Notification clicked: ${event.notification.title}',
        );

        final notif = NotificationModel(
          id: event.notification.notificationId,
          title: event.notification.title ?? 'Notification',
          subtitle: event.notification.body ?? '',
          timestamp: DateTime.now(),
          iconType: 'default',
          payload: event.notification.additionalData?.toString(),
        );
        _addNotification(notif);
      });

      debugPrint("OneSignal initialized successfully");
    } catch (e) {
      debugPrint("OneSignal initialization error: $e");
    }

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint("Local notification clicked: ${details.payload}");
        },
      );

      if (Platform.isAndroid) {
        final androidImplementation = _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await androidImplementation?.requestNotificationsPermission();
      }

      debugPrint("Local Notification Service initialized successfully");
    } catch (e) {
      debugPrint("Local Notification Service initialization error: $e");
    }
  }

  static Future<void> refreshNotifications() async {
    await _loadNotifications();
  }

  static Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        notificationsNotifier.value = jsonList
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      } catch (e) {
        debugPrint("Error loading notifications: $e");
      }
    }
  }

  static Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notificationsNotifier.value
        .map((e) => e.toJson())
        .toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  static void _addNotification(NotificationModel notif) {
    final current = List<NotificationModel>.from(notificationsNotifier.value);

    if (current.any((n) => n.id == notif.id)) {
      return;
    }

    current.insert(0, notif);
    if (current.length > 50) current.removeLast();
    notificationsNotifier.value = current;
    _saveNotifications();
  }

  static Future<void> saveRemoteMessage(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    List<dynamic> jsonList = [];
    if (data != null) {
      try {
        jsonList = jsonDecode(data);
      } catch (_) {}
    }

    final notif = NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Notification',
      subtitle: message.notification?.body ?? '',
      timestamp: DateTime.now(),
      iconType: 'default',
      payload: message.data.toString(),
    );

    jsonList.insert(0, notif.toJson());
    if (jsonList.length > 50) jsonList.removeLast();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  static Future<void> saveOneSignalNotification(
    OSNotification notification,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    List<dynamic> jsonList = [];
    if (data != null) {
      try {
        jsonList = jsonDecode(data);
      } catch (_) {}
    }

    final notif = NotificationModel(
      id: notification.notificationId,
      title: notification.title ?? 'Notification',
      subtitle: notification.body ?? '',
      timestamp: DateTime.now(),
      iconType: 'default',
      payload: notification.additionalData?.toString(),
    );

    jsonList.insert(0, notif.toJson());
    if (jsonList.length > 50) jsonList.removeLast();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Show SMS verification code notification
  static Future<void> showSmsNotification({required String code}) async {
    final notif = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "Verification Code",
      subtitle: "Your verification code is: $code",
      timestamp: DateTime.now(),
      iconType: 'sms',
      iconColor: Colors.blue,
    );

    // Show actually
    await showLocalNotification(
      title: notif.title,
      body: notif.subtitle,
      id: 1,
    );

    _addNotification(notif);
  }

  static Future<void> removeNotification(String id) async {
    final current = List<NotificationModel>.from(notificationsNotifier.value);
    current.removeWhere((n) => n.id == id);
    notificationsNotifier.value = current;
    await _saveNotifications();
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          channelDescription: 'General app notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final notificationId =
        id ??
        (title.hashCode + body.hashCode + DateTime.now().millisecond).remainder(
          100000,
        );

    await _localNotificationsPlugin.show(
      notificationId,
      title,
      body,
      details,
      payload: payload,
    );
  }

  static Future<void> setPushEnabled(bool enabled) async {
    if (enabled) {
      OneSignal.User.pushSubscription.optIn();
    } else {
      OneSignal.User.pushSubscription.optOut();
    }
  }

  static bool isPushEnabled() {
    return OneSignal.User.pushSubscription.optedIn ?? false;
  }

  static Future<void> cancelAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
    notificationsNotifier.value = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  static void addTestNotification({
    required String title,
    required String body,
  }) {
    _addNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        subtitle: body,
        timestamp: DateTime.now(),
        iconType: 'default',
      ),
    );
  }
}
