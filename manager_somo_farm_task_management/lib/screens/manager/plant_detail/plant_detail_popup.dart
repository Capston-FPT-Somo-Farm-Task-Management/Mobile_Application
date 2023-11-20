import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
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
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => UpdatePlant(plant: plant),
                ),
              )
                  .then((value) {
                if (value != null) {
                  Navigator.of(context).pop("ok");
                }
              });
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
                Flexible(
                  child: TitleText.titleText(
                      "Mã cây trồng", '${plant['externalId']}', 18),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.tree,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Loại cây", '${plant['habitantTypeName']}', 18),
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
                Flexible(
                  child: TitleText.titleText(
                      "Chiều cao", '${plant['height']} mét', 18),
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
                Flexible(
                  child: TitleText.titleText(
                      "Ngày tạo",
                      '${DateFormat('dd/MM/yyyy').format(DateTime.parse(plant['createDate']))}',
                      18),
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
                Flexible(
                  child: TitleText.titleText(
                      "Khu vực", '${plant['areaName']}', 18),
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
                Flexible(
                  child:
                      TitleText.titleText("Vùng", '${plant['zoneName']}', 18),
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
                Flexible(
                  child: TitleText.titleText(
                      "Khu đất", '${plant['fieldName']}', 18),
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
