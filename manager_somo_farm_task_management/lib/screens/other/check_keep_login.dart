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
  Farm farm = products.first;
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
      farm = products.where((f) => f.id == storedFarmId).singleOrNull!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData || (username != null)) {
              // Nếu đã đăng nhập bằng Firebase Auth hoặc có thông tin từ SharedPreferences
              return ManagerHomePage(farm: farm);
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
