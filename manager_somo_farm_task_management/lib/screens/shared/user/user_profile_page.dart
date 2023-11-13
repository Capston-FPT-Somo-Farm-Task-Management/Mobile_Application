import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/shared/user_update/user_update_profile_page.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;
  final int farmId;

  const UserProfilePage({Key? key, required this.userId, required this.farmId})
      : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    GetUser(widget.userId).then((value) {
      setState(() {
        isLoading = false;
        if (value.isNotEmpty) {
          setState(() {
            userData = value['data'];
          });
        }
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
        padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 20),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              )
            : userData == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.not_interested_sharp,
                          size: 75,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Không thể hiện farm ngay lúc này",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => _loadUserData(),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            userData!['avatar'] != null
                                ? Container(
                                    height: 150,
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
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
                            SizedBox(height: 35),
                            Container(
                              padding: EdgeInsets.all(30),
                              constraints: BoxConstraints(
                                minHeight: 150, // Chiều cao tối thiểu
                                minWidth: 300, // Chiều rộng tối thiểu
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                                  Row(
                                    children: [
                                      Text(
                                        "Mã nhân viên: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData != null
                                            ? userData!['code'] != null
                                                ? '${userData!['code']}'
                                                : 'chưa có'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Text(
                                        "Chức vụ: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData != null
                                            ? userData!['roleName'] != null
                                                ? userData!['roleName'] ==
                                                        "Manager"
                                                    ? "Quản lí trang trại"
                                                    : "Giám sát trang trại"
                                                : 'chưa có'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Text(
                                        "Email: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData != null
                                            ? userData!['email'] != null
                                                ? '${userData!['email']}'
                                                : 'chưa có'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Text(
                                        "Tên tài khoản: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData != null
                                            ? userData!['userName'] != null
                                                ? '${userData!['userName']}'
                                                : 'chưa có'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Text(
                                        "Mật khẩu: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData != null
                                            ? userData!['password'] == null
                                                ? '${'*' * userData!['password'].toString().length}'
                                                : '***************'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              constraints: BoxConstraints(
                                minHeight: 150, // Chiều cao tối thiểu
                                minWidth: 300, // Chiều rộng tối thiểu
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Số điện thoại: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData != null
                                            ? userData!['phoneNumber'] != null
                                                ? '${userData!['phoneNumber']}'
                                                : 'chưa có'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Text(
                                        "Ngày sinh: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        userData != null
                                            ? userData!['birthday'] != null
                                                ? '${DateFormat('dd/MM/yyyy').format(DateTime.parse(userData!['birthday']))}'
                                                : 'chưa có'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Địa chỉ: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          userData != null
                                              ? userData!['address'] != null
                                                  ? '${userData!['address']}'
                                                  : 'chưa có'
                                              : '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateUser(user: userData!),
                                  ),
                                )
                                    .then((value) {
                                  if (value != null) {
                                    _loadUserData();
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kPrimaryColor),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(100, 50)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                              child: Text('Chỉnh sửa thông tin'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
