import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/models/farm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manager/home/manager_home_page.dart';
import 'login_page.dart';

class CheckKeepLogin extends StatefulWidget {
  const CheckKeepLogin({super.key});

  @override
  CheckKeepLoginState createState() => CheckKeepLoginState();
}

class CheckKeepLoginState extends State<CheckKeepLogin> {
  String? username; // Thêm biến để lưu tên người dùng từ SharedPreferences
  int? farmId;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Kiểm tra trạng thái đăng nhập từ SharedPreferences
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedFarmId = prefs.getInt('farmId');

    setState(() {
      username = storedUsername;
      farmId = storedFarmId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (farmId == null) {
      return LoginPage();
    }
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              // Nếu đã đăng nhập bằng Firebase Auth hoặc có thông tin từ SharedPreferences
              return ManagerHomePage(farmId: farmId!);
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
