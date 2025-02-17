import 'package:flutter/material.dart';
import 'package:flutter_firebase_push_notification/controllers/auth_services.dart';
import 'package:flutter_firebase_push_notification/controllers/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    PushNotification.getDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Home Screen"),
      actions: [
        IconButton(
            onPressed: () async {
              await AuthServices.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
            icon: const Icon(Icons.logout))
      ],
    ));
  }
}
