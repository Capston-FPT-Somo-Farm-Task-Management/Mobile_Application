import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';
import 'package:manager_somo_farm_task_management/screens/manager/habitantType_update/habitantType_update_page.dart';

class HabitantTypeDetailPopup extends StatelessWidget {
  final Map<String, dynamic> habitantType;

  const HabitantTypeDetailPopup({required this.habitantType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
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
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) =>
                      UpdateHabitantType(habitantType: habitantType),
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
            habitantType['status'] == "Thực vật"
                ? Row(
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
                            "Loại cây trồng", "${habitantType['name']}", 18),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        FontAwesomeIcons.paw,
                        color: kSecondColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TitleText.titleText(
                            "Loại vật nuôi", " ${habitantType['name']}", 18),
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
                TitleText.titleText("Thuộc loại",
                    wrapWords(" ${habitantType['status']}", 22), 18),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.locationDot,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Nông trại", " ${habitantType['farmName']}", 18),
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
                Flexible(
                  child: TitleText.titleText(
                      "Xuất xứ",
                      habitantType['origin'] == null
                          ? 'chưa có'
                          : '${habitantType['origin']}',
                      18),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.cloud,
                  color: kSecondColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: TitleText.titleText(
                      "Môi trường sống",
                      habitantType['environment'] == null
                          ? 'chưa có'
                          : '${habitantType['environment']}',
                      18),
                ),
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
                      habitantType['description'] == null
                          ? 'chưa có'
                          : '${habitantType['description']}',
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
