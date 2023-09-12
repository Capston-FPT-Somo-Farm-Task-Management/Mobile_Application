import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

import '../manager/farm_list_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Logo
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height /
                      3, // Chiếm 1/3 chiều cao màn hình
                  child: FractionallySizedBox(
                    widthFactor: 1 / 2.5,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Username Field
              const Text(
                "Username",
                style: TextStyle(
                  color: kSecondLightColor, // Màu 8CAAB9
                  fontSize: 16.0,
                ), // Đặt text nằm bên trái
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: kSecondColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  style: const TextStyle(color: kTextWhiteColor),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: kTextWhiteColor),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: kTextWhiteColor),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Password Field
              const Text(
                "Password",
                style: TextStyle(
                  color: kSecondLightColor, // Màu 8CAAB9
                  fontSize: 16.0,
                ), // Đặt text nằm bên trái
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: kSecondColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  style: const TextStyle(color: kTextWhiteColor),
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: kTextWhiteColor),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: kTextWhiteColor),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: kSecondLightColor, // Màu 8CAAB9
                    fontSize: 16.0,
                  ),
                ),
              ),

              const SizedBox(height: 70.0),

              // Login Button
              InkWell(
                onTap: () {
                  // Xử lý khi Container được nhấn, ví dụ: chuyển đến trang home
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const FarmListPage(),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: kTextWhiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
