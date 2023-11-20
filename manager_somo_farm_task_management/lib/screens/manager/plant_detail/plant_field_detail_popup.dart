import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant_update/plant_field_update_page.dart';

class PlantFieldDetailsPopup extends StatelessWidget {
  final Map<String, dynamic> plantField;
  const PlantFieldDetailsPopup({required this.plantField});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '${plantField['name']}',
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
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
                  builder: (context) => UpdatePlantField(plantFied: plantField),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.tag,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Mã vườn", '${plantField['code']}', 18),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.chartArea,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Diện tích", '${plantField['area']} mét vuông', 18),
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
                      "Khu vực", '${plantField['areaName']}', 18),
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
                  child: TitleText.titleText(
                      "Vùng", '${plantField['zoneName']}', 18),
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
