import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
import 'package:manager_somo_farm_task_management/screens/manager/employee_update/employee_update_page.dart';

class EmployeeDetailsPopup extends StatelessWidget {
  final Map<String, dynamic> employee;
  final int farmId;
  const EmployeeDetailsPopup({required this.employee, required this.farmId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  employee['avatar'] != null
                      ? Container(
                          height: 70,
                          width: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              employee['avatar'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 70,
                          width: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      employee['name'],
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.mode_edit_outline_outlined,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => UpdateEmployee(
                    farmId: farmId,
                    employee: employee,
                  ),
                ),
              )
                  .then((value) {
                if (value != null) {
                  Navigator.of(context).pop("ok");
                }
              });
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.tag,
                  color: kSecondColor,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: TitleText.titleText(
                      "Mã nhân viên", '${employee['code']}', 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                TitleText.titleText(
                    "Số điện thoại", '${employee['phoneNumber']}', 18),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.date_range_outlined,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                TitleText.titleText(
                    "Ngày sinh",
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(employee['dateOfBirth'])),
                    18),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.venusMars,
                  size: 18,
                  color: kSecondColor,
                ),
                const SizedBox(width: 14),
                TitleText.titleText("Số điện thoại",
                    employee['gender'] == "Female" ? "Nữ" : "Nam", 18),
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
                Flexible(
                  child: TitleText.titleText(
                      "Địa chỉ", '${employee['address']}', 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.emoji_symbols_sharp,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TitleText.titleText(
                      "Kĩ năng", '${employee['taskTypeName']}', 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TitleText.titleText(
                      "Trạng thái", '${employee['status']}', 18),
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
