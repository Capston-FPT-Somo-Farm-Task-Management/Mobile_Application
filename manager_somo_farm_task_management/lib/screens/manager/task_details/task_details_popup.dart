import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/models/task.dart';

class TaskDetailsPopup extends StatelessWidget {
  final Task task;

  const TaskDetailsPopup({required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            task.name,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(
            Icons.mode_edit_outline_outlined,
            color: kPrimaryColor,
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
                  task.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bắt đầu: ${DateFormat('HH:mm a  -  dd/MM/yyyy').format(task.startDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'kết thúc: ${DateFormat('HH:mm a  -  dd/MM/yyyy').format(task.endDate)}',
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
                  Icons.access_time,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(task.createDate)}',
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
                  'Ưu tiên: ${Priority.getPriority(task.priority)}',
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
                  Icons.work,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Loại công việc: ${task.taskTypeId}',
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
                  Icons.supervised_user_circle,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Người quản lí: ${task.managerId}',
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
                  Icons.person,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Người giám sát: ${task.supervisorId}',
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
                  Icons.business,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Field ID: ${task.fieldId}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (task.otherId != null)
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: kSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Other: ${task.otherId}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (task.habitantId != null)
              Row(
                children: [
                  const Icon(
                    Icons.home,
                    color: kSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Habitant: ${task.habitantId}',
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
                  Icons.check_circle,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Trạng thái: ${task.status}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.repeat,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Iterations: ${task.iterations}',
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
                  Icons.notifications,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Nhắc nhở: ${task.remind} phút trước khi bắt đầu',
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
                  'Repeat: ${task.repeat}',
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
