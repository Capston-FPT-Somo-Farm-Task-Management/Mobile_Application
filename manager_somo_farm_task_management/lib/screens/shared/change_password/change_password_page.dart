import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';

class ChangePasswordPage extends StatefulWidget {
  final int userId;

  const ChangePasswordPage({super.key, required this.userId});
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String errorText = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(
          "Đổi mật khẩu",
          style: headingStyle.copyWith(fontSize: 25),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: kSecondColor,
          ),
        ),
      ),
      body: isLoading
          ? CircularProgressIndicator(
              color: kPrimaryColor,
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    obscureText: true,
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Nhập Mật Khẩu Cũ',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Nhập Mật Khẩu Mới',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Xác Nhận Mật Khẩu Mới',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          kPrimaryColor, // Đổi màu nền của nút ở đây
                    ),
                    onPressed: () {
                      if (oldPasswordController.text.trim().isEmpty ||
                          newPasswordController.text.trim().isEmpty ||
                          confirmPasswordController.text.trim().isEmpty) {
                        // Show an error message or handle the case where fields are empty
                        SnackbarShowNoti.showSnackbar(
                            "Vui lòng điền đầy đủ thông tin", true);
                        return;
                      }

                      // Check if newPassword and confirmPassword match
                      if (newPasswordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        SnackbarShowNoti.showSnackbar(
                            "Mật khẩu mới không trùng khớp", true);
                        return;
                      }
                      Map<String, dynamic> data = {
                        "oldPassword": oldPasswordController.text.trim(),
                        "password": newPasswordController.text.trim(),
                        "confirmPassword":
                            confirmPasswordController.text.trim(),
                      };

                      UserService()
                          .changePassword(widget.userId, data)
                          .then((value) {
                        if (value) {
                          SnackbarShowNoti.showSnackbar(
                              "Đã cập nhật mật khẩu mới", false);
                          Navigator.of(context).pop();
                        }
                      }).catchError((e) {
                        SnackbarShowNoti.showSnackbar(e.toString(), true);
                      });
                    },
                    child: Text('Đổi Mật Khẩu'),
                  ),
                ],
              ),
            ),
    );
  }
}
