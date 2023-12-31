import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/change_password/change_password_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/user/user_profile_page.dart';
import 'package:manager_somo_farm_task_management/services/hub_connection_service.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = true;
  int? userId;
  int? farmId;
  Map<String, dynamic>? userData;
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');
    return storedUserId;
  }

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  Future<void> _loadUserData() async {
    GetUser(userId!).then((value) {
      setState(() {
        userData = value['data'];
        isLoading = false;
      });
    });
  }

  Future<Map<String, dynamic>> GetUser(int userId) {
    return UserService().getUserById(userId);
  }

  @override
  initState() {
    super.initState();
    getUserId().then((value) {
      userId = value;
      _loadUserData();
    });
    getFarmId().then((value) {
      farmId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                userData!['avatar'] != null
                    ? Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  userData!['avatar'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData != null ? userData!['name'] : '',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
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
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                  userId: userId!, farmId: farmId!),
                            ),
                          )
                              .then(
                            (value) {
                              _loadUserData();
                            },
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Đổi mật khẩu'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangePasswordPage(userId: userId!),
                            ),
                          );
                        },
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
