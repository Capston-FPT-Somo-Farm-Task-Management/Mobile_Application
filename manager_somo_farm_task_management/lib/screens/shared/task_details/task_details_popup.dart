import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';

class TaskDetailsPopup extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailsPopup({required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            wrapWords(task['name'], 20),
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateTaskPage(task: task),
                ),
              );
            },
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  task['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (task['otherName'] != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: kSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    wrapWords('Đối tượng: ${task['otherName']}', 35),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            if (task['plantName'] != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.home,
                    color: kSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    wrapWords('Cây: ${task['plantName']}', 35),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            if (task['plantName'] != null) const SizedBox(height: 16),
            if (task['plantName'] != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.tag,
                    color: kSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    wrapWords('Mã cây: ${task['externalId']}', 35),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            if (task['liveStockName'] != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.home,
                    color: kSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    wrapWords('Con vật: ${task['liveStockName']}', 35),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            if (task['liveStockName'] != null) const SizedBox(height: 16),
            if (task['liveStockName'] != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.tag,
                    color: kSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    wrapWords('Mã con vật: ${task['externalId']}', 35),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.mapLocationDot,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Khu vực: ${task['areaName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.borderNone,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Vùng: ${task['zoneName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.business,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Chuồng: ${task['fieldName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(task['createDate']))}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bắt đầu: ${DateFormat('HH:mm a  -  dd/MM/yyyy').format(DateTime.parse(task['startDate']))}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'kết thúc: ${DateFormat('HH:mm a  -  dd/MM/yyyy').format(DateTime.parse(task['endDate']))}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.supervised_user_circle,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Người quản lí: ${task['managerName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Người giám sát: ${task['supervisorName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Thực hiện: ${task['employeeName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.handyman_outlined,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Dụng cụ: ${task['materialName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.priority_high,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ưu tiên: ${task['priority']}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.work,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Loại công việc: ${task['taskTypeName']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.notifications,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords(
                      'Nhắc nhở: ${task['remind']} phút trước khi bắt đầu', 35),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.repeat,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Lặp lại: ${task['repeat']}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Trạng thái: ${task['status']}', 35),
                  style: const TextStyle(
                    fontSize: 16,
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
