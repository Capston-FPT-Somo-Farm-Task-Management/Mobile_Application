import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
import 'package:manager_somo_farm_task_management/screens/manager/taskType_update/taskType_update_page.dart';

class TaskTypeDetailPopup extends StatelessWidget {
  final Map<String, dynamic> taskType;

  const TaskTypeDetailPopup({required this.taskType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Chi tiết loại công việc",
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
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => UpdateTaskType(taskType: taskType),
                ),
              )
                  .then(
                (value) {
                  if (value != null) {
                    Navigator.of(context).pop("ok");
                  }
                },
              );
            },
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (taskType['status'] == "Công việc chăn nuôi")
                  const Icon(
                    FontAwesomeIcons.paw,
                    color: kSecondColor,
                    size: 20,
                  ),
                if (taskType['status'] == "Công việc cây trồng")
                  const Icon(
                    FontAwesomeIcons.tree,
                    color: kSecondColor,
                    size: 20,
                  ),
                if (taskType['status'] == "Công việc khác")
                  const Icon(
                    FontAwesomeIcons.hashtag,
                    color: kSecondColor,
                    size: 20,
                  ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Tên loại công việc", "${taskType['name']}", 18),
                )
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.rulerVertical,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Loại công việc", "${taskType['status']}", 18),
                )
              ],
            ),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.scroll,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Mô tả",
                      taskType['description'] == null
                          ? 'chưa có'
                          : '${taskType['description']}',
                      18),
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
