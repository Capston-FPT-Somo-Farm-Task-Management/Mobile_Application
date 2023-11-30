import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  // Biểu thức chính quy để kiểm tra địa chỉ email
  final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(
          "Đặt lại mật khẩu",
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhập địa chỉ email đã đăng ký của bạn để đặt lại mật khẩu.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Kiểm tra xem chuỗi nhập vào có đúng là địa chỉ email không
                      String userEmail = emailController.text;
                      if (emailRegExp.hasMatch(userEmail)) {
                        // Đặt logic để gửi email đặt lại mật khẩu ở đây
                        UserService().resetPassword(userEmail).then((value) {
                          if (value) {
                            Navigator.of(context).pop();
                            SnackbarShowNoti.showSnackbar(
                                "Chúng tôi đã gửi mật khẩu mới vào mail, hãy kiểm tra",
                                false);
                          }
                        }).catchError((e) {
                          SnackbarShowNoti.showSnackbar(e.toString(), true);
                        });
                      } else {
                        SnackbarShowNoti.showSnackbar(
                            "Địa chỉ email không hợp lệ", true);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Gửi Yêu Cầu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
