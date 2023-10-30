import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/user/user_profile_page.dart';
import 'package:manager_somo_farm_task_management/services/hub_connection_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = false;
  int? userId;
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');
    return storedUserId;
  }

  @override
  initState() {
    super.initState();
    getUserId().then((value) {
      userId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading
          ? null
          : AppBar(
              backgroundColor: Colors.white10,
              elevation: 0,
              automaticallyImplyLeading: false, // Ẩn nút quay lại
              centerTitle: true,
              title: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'Cài đặt',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tài khoản',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Thông tin cá nhân'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UserProfilePage(userId: userId!),
                          ));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Đổi mật khẩu'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cài đặt chung',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ListTile(
                        leading: const Icon(Icons.output_outlined),
                        title: const Text('Đăng xuất'),
                        onTap: () async {
                          // Điều hướng đến trang LoginPage
                          setState(() {
                            isLoading = true;
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final tokenDevice = prefs.getString('tokenDevice');
                          await HubConnectionService()
                              .deleteConnection(tokenDevice!)
                              .then((value) {
                            if (value) {
                              setState(() {
                                isLoading = false;
                              });
                              prefs.clear();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }
                          }).catchError((e) {
                            SnackbarShowNoti.showSnackbar(e.toString(), true);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
