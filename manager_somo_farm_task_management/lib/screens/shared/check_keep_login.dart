import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class CheckKeepLogin extends StatefulWidget {
  const CheckKeepLogin({super.key});

  @override
  CheckKeepLoginState createState() => CheckKeepLoginState();
}

class CheckKeepLoginState extends State<CheckKeepLogin> {
  int? userId;
  int? farmId;
  String? role;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await checkLoginStatus();

    // Kiểm tra farmId và xác định trang để chuyển đến.
    if (farmId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(
          () {}); // Gọi setState để rebuild widget và hiển thị trang chính.
    }
  }

  // Kiểm tra trạng thái đăng nhập từ SharedPreferences
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getInt('userId');
    final storedFarmId = prefs.getInt('farmId');
    final storedRole = prefs.getString('role');
    setState(() {
      userId = storedUsername;
      farmId = storedFarmId;
      role = storedRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: farmId == null
            ? const CircularProgressIndicator()
            : farmId == null
                ? LoginPage()
                : BottomNavBar(
                    farmId: farmId!,
                    index: 0,
                  ),
      ),
    );
  }
}
