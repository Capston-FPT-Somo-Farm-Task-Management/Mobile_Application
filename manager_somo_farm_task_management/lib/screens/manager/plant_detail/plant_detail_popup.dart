import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant_update/plant_update_page.dart';

class PlantDetailPopup extends StatelessWidget {
  final Map<String, dynamic> plant;

  const PlantDetailPopup({required this.plant});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            plant['name'],
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
                  builder: (context) => UpdatePlant(plant: plant),
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
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.tag,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Mã cây trồng: ${plant['externalId']}',
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
                  FontAwesomeIcons.tree,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Loại cây: ${plant['habitantTypeName']}',
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
                  'Chiều cao: ${plant['height']} mét',
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
                  'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(plant['createDate']))}',
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
                  'Khu vực: ${plant['areaName']}',
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
                  'Vùng: ${plant['zoneName']}',
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
                  FontAwesomeIcons.tree,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Khu đất: ${plant['fieldName']}',
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
