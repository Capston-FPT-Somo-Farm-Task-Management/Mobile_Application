import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';

class SupervisorDetailsPopup extends StatelessWidget {
  final Map<String, dynamic> supervisor;

  const SupervisorDetailsPopup({required this.supervisor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            wrapWords(supervisor['name'], 20),
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.mode_edit_outline_outlined,
              color: kPrimaryColor,
            ),
            onPressed: () {
              // Navigator.of(context).push(
              //           MaterialPageRoute(
              //             builder: (context) =>  FirstUpdateTaskPage(task: task),
              //           ),
              //         );
            },
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.tag,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Mã nhân viên: ${supervisor['code']}', 35),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Email: ${supervisor['email']}', 35),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_box,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Tài khoản: ${supervisor['userName']}', 35),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.key,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Mật khẩu: ${supervisor['password']}', 35),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ngày sinh: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(supervisor['birthday']))}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Điện thoại: ${supervisor['phoneNumber']}', 35),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.house_outlined,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Địa chỉ: ${supervisor['address']}', 35),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Trạng thái: ${supervisor['status']}', 35),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Đóng',
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
