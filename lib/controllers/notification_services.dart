import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_push_notification/controllers/auth_services.dart';
import 'package:flutter_firebase_push_notification/controllers/crud_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_firebase_push_notification/main.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true);

    // // Get the device token
    // final token = await _firebaseMessaging.getToken();
    // print("Device Token: $token");
  }

  static Future getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    print("Device Token: $token");
    bool isUserLoggedin = await AuthServices.isLoggedIn();

    // save the token to the firebase database if login is true

    if (isUserLoggedin) {
      await CrudServices.saveUserToken(token!);
      print("save to the firestore");
    }

    // also save if token changes
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (isUserLoggedin) {
        await CrudServices.saveUserToken(token!);
        print("save to the firestore");
      }
    });
  }

  // Initialize local notification
  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    // Notification request for Android 13 or above
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap,
        onDidReceiveNotificationResponse: onNotificationTap);
  }

  // On tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    // Passing the notification response correctly
    navigatorkey.currentState!
        .pushNamed("/message", arguments: notificationResponse);
  }

  // Show simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String playLoad,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            channelDescription: "This About to check the local notification",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "Ticker");
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: playLoad);
  }
}
