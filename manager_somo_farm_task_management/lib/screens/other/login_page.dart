import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/home/manager_home_page.dart';
import 'package:manager_somo_farm_task_management/services/google_authentication_service.dart';
import 'package:manager_somo_farm_task_management/services/login_services.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  String username = "";
  String password = "";
  LoginPage({super.key});

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
                "Tài khoản",
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
                    hintText: 'Tài khoản',
                    hintStyle: TextStyle(color: kTextWhiteColor, height: 1.4),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    username = value;
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Password Field
              const Text(
                "Mật khẩu",
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
                    hintText: 'Mật khẩu',
                    hintStyle: TextStyle(color: kTextWhiteColor, height: 1.4),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: kSecondLightColor, // Màu 8CAAB9
                    fontSize: 16.0,
                  ),
                ),
              ),

              const SizedBox(height: 70.0),

              // Login Button
              InkWell(
                onTap: () async {
                  try {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final result =
                        await LoginService().Login(username, password);
                    String role = result['role'];
                    int id = result['id'];

                    int farmId =
                        await UserService().getUserById(id).then((value) {
                      prefs.setInt('farmId', value['data']['farmId']);
                      return value['data']['farmId'];
                    }).catchError((e) {
                      SnackbarShowNoti.showSnackbar(context, e, true);
                      return 0; // Trả về giá trị mặc định nếu có lỗi
                    });

                    if (role == "Manager") {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ManagerHomePage(farmId: farmId),
                        ),
                      );
                    }
                  } catch (e) {
                    SnackbarShowNoti.showSnackbar(
                        context, "Tài khoản hoặc mật khẩu không đúng!", true);
                  }
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
              const SizedBox(height: 30.0),
              Center(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    AuthService().signInWithGoogle();
                  },
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png',
                    height: 32,
                    width: 32,
                  ),
                  label: const Text('Đăng nhập bằng Google'),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
