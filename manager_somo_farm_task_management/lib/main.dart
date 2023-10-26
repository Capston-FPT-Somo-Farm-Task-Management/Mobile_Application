import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/screens/shared/check_keep_login.dart';
import 'package:manager_somo_farm_task_management/services/firebase_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Somo Farm Task Management',
      home: CheckKeepLogin(),
      routes: {},
    );
  }
}
