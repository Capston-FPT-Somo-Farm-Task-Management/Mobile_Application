import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/dashboard/dashboard_page.dart';
import 'package:manager_somo_farm_task_management/services/hub_connection_service.dart';
import 'package:manager_somo_farm_task_management/services/login_services.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';
import 'package:manager_somo_farm_task_management/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  bool isLoading = false;
  Future<bool> getDeviceToken(int userId) async {
    await FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      var data = {"connectionId": value, "memberId": userId};
      HubConnectionService().createConnection(data).then((r) {
        saveTokenDevice(value!);
        return r;
      });
    });
    return false;
  }

  Future<void> saveTokenDevice(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tokenDevice', token);
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : Container(
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
                          prefixIcon:
                              Icon(Icons.person, color: kTextWhiteColor),
                          hintText: 'Tài khoản',
                          hintStyle:
                              TextStyle(color: kTextWhiteColor, height: 1.4),
                          border: InputBorder.none,
                        ),
                        controller: _usernameController,
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
                          hintStyle:
                              TextStyle(color: kTextWhiteColor, height: 1.4),
                          border: InputBorder.none,
                        ),
                        controller: _passwordController,
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
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final result = await LoginService().Login(
                              _usernameController.text,
                              _passwordController.text);
                          String role = result['role'];
                          int userId = result['id'];
                          prefs.setString('role', role);
                          int farmId = await UserService()
                              .getUserById(userId)
                              .then((value) {
                            prefs.setInt('farmId', value['data']['farmId']);
                            return value['data']['farmId'];
                          }).catchError((e) {
                            print(e);
                            SnackbarShowNoti.showSnackbar(e, true);
                            return 0; // Trả về giá trị mặc định nếu có lỗi
                          });

                          if (role == "Manager" || role == "Supervisor") {
                            // setState(() {
                            //   isLoading = false;
                            // });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(
                                  farmId: farmId,
                                  index: 0,
                                  page: StatisticsPage(),
                                ),
                              ),
                            );
                            getDeviceToken(userId);
                            SnackbarShowNoti.showSnackbar(
                                "Đăng nhập thành công!", false);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            SnackbarShowNoti.showSnackbar(
                                "Vai trò không hợp lệ", false);
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          SnackbarShowNoti.showSnackbar(
                              "Tài khoản hoặc mật khẩu không đúng!", true);
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
                    // Center(
                    //   child: FloatingActionButton.extended(
                    //     onPressed: () {
                    //       AuthService().signInWithGoogle();
                    //     },
                    //     icon: Image.network(
                    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png',
                    //       height: 32,
                    //       width: 32,
                    //     ),
                    //     label: const Text('Đăng nhập bằng Google'),
                    //     backgroundColor: Colors.white,
                    //     foregroundColor: Colors.black,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
