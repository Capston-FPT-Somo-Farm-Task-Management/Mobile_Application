import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant_update/plant_update_page.dart';

class HabitantTypeDetailPopup extends StatelessWidget {
  final Map<String, dynamic> habitantType;

  const HabitantTypeDetailPopup({required this.habitantType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          habitantType["status"] == "Thực vật"
              ? Text(
                  "Chi tiết loại cây",
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  "Chi tiết loại vật nuôi",
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
                  builder: (context) => UpdatePlant(plant: habitantType),
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
            habitantType['status'] == "Thực vật"
                ? Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.tree,
                        color: kSecondColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Loại cây: ${habitantType['name']}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.paw,
                        color: kSecondColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Loại vật nuôi: ${habitantType['name']}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
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
                Text(
                  'ĐV/TV: ${habitantType['status']}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.locationDot,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Nông trại: ${habitantType['farmName']}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.earthAfrica,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Xuất xứ: ${habitantType['origin']}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.cloud,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Môi trường sống: ${habitantType['environment']}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.scroll,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Mô tả: ${habitantType['description']}',
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
