import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/livestock.dart';
import 'package:manager_somo_farm_task_management/models/plant.dart';

class LiveStockDetailsPopup extends StatelessWidget {
  final Map<String, dynamic> liveStock;
  const LiveStockDetailsPopup({required this.liveStock});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            liveStock['name'],
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 30,
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
              children: [
                const Icon(
                  FontAwesomeIcons.tag,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Mã động vật: ${liveStock['externalId']}',
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
                  FontAwesomeIcons.paw,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Loại: ${liveStock['habitantTypeName']}',
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
                  FontAwesomeIcons.venusMars,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Giới tính: ${liveStock['gender']}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(liveStock['dateOfBirth']))}',
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
                  Icons.access_time_filled,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ngày sinh: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(liveStock['createDate']))}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.map,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Khu vực: ${liveStock['areaName']}',
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
                  'Vùng: ${liveStock['zoneName']}',
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
                  FontAwesomeIcons.horseHead,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Khu đất: ${liveStock['fieldName']}',
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
