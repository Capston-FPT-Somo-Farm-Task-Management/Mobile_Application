import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/screens/other/check_keep_login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Somo Farm Task Management',
      home: CheckKeepLogin(),
    );
  }
}
