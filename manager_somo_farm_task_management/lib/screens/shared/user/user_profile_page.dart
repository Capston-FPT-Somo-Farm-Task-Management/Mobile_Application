import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';
import 'package:manager_somo_farm_task_management/widgets/app_bar.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    GetUser(widget.userId).then((value) {
      setState(() {
        userData = value['data'];
      });
    });
  }

  Future<Map<String, dynamic>> GetUser(int userId) {
    return UserService().getUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back, color: kSecondColor)),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  userData!['avatar'] != null
                      ? Container(
                          height: 150,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              userData!['avatar'],
                              fit: BoxFit.cover,
                            ),
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
                  SizedBox(height: 25),
                  Container(
                    padding: EdgeInsets.all(30),
                    height: 250,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Thông tin nhân viên",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['code'] != null
                                    ? 'Mã nhân viên: ${userData!['code']}'
                                    : 'Mã nhân viên: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['roleName'] != null
                                    ? 'Chức vụ: ${userData!['roleName']}'
                                    : 'Chức vụ: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['email'] != null
                                    ? 'Email: ${userData!['email']}'
                                    : 'Mã nhân viên: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['userName'] != null
                                    ? 'Tên tài khoản: ${userData!['userName']}'
                                    : 'Tên tài khoản: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['password'] != null
                                    ? 'Mật khẩu: ${'**' * userData!['password'].toString().length}'
                                    : 'Mật khẩu: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(30),
                    height: 200,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['phoneNumber'] != null
                                    ? 'Số điện thoại: ${userData!['phoneNumber']}'
                                    : 'Số điện thoại: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['birthday'] != null
                                    ? 'Ngày sinh: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(userData!['birthday']))}'
                                    : 'Ngày sinh: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userData != null
                                ? userData!['address'] != null
                                    ? 'Địa chỉ: ${userData!['address']}'
                                    : 'Địa chỉ: chưa có'
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
