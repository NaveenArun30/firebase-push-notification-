import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_push_notification/controllers/auth_services.dart';
import 'package:flutter_firebase_push_notification/controllers/message.dart';
import 'package:flutter_firebase_push_notification/views/home_page.dart';
import 'package:flutter_firebase_push_notification/views/login_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'controllers/notification_services.dart';
import 'firebase_options.dart';
import 'views/signup_page.dart';

final navigatorkey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification received in background");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Firebase messaging
  await PushNotification.init();
  // Initialize local notifications
  await PushNotification.localNotiInit();
  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // On background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background notification is tapped,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      navigatorkey.currentState!.pushNamed("/message", arguments: message);
    }
  });

  // to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got the notification in the Foreground Successfully");
    if (message.notification != null) {
      print("ForeGround notification is tapped..............................,");
      PushNotification.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          playLoad: payloadData);
    }
  });

  // for handling in the terminated state

  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("Message from the terminated state >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    Future.delayed(Duration(seconds: 1), () {
      navigatorkey.currentState!.pushNamed("/message", arguments: message);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      navigatorKey: navigatorkey,
      routes: {
        "/checkuser": (context) => const ChechUserLogin(),
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignUpPage(),
        "/homepage": (context) => const HomePage(),
        "/message": (context) => const Message(),
      },
    );
  }
}

class ChechUserLogin extends StatefulWidget {
  const ChechUserLogin({super.key});

  @override
  State<ChechUserLogin> createState() => _ChechUserLoginState();
}

class _ChechUserLoginState extends State<ChechUserLogin> {
  @override
  void initState() {
    super.initState();
    AuthServices.isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/homepage");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
