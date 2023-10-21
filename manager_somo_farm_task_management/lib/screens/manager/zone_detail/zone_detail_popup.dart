import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';
import 'package:manager_somo_farm_task_management/screens/manager/area_update/area_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/zone_update/zone_update_pagge.dart';

class ZoneDetail extends StatelessWidget {
  final Map<String, dynamic> zone;
  const ZoneDetail({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            wrapWords(zone['name'], 20),
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
                  builder: (context) => UpdateZone(zone: zone),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.tag,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Mã vùng: ${zone['code']}', 35),
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
                  Icons.home,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Khu vực: ${zone['areaName']}', 35),
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
                  Icons.api,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Loại vùng: ${zone['zoneTypeName']}', 35),
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
                  FontAwesomeIcons.chartArea,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  wrapWords('Diện tích: ${zone['farmArea']} mét vuông', 35),
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
                  wrapWords('Trạng thái: ${zone['status']}', 35),
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
