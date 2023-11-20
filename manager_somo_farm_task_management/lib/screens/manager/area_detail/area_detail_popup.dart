import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';
import 'package:manager_somo_farm_task_management/screens/manager/area_update/area_update_page.dart';

class AreaDetail extends StatelessWidget {
  final Map<String, dynamic> area;
  const AreaDetail({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            wrapWords(area['name'], 20),
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
                  builder: (context) => UpdateArea(area: area),
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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Mã khu vực: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                      TextSpan(
                        text: '${area['code']}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      )
                    ],
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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Nông trại: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                      TextSpan(
                        text: wrapWords('${area['farmName']}', 35),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      )
                    ],
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
                TitleText.titleText(
                    "Diện tích", wrapWords('${area['fArea']} mét vuông', 35)),
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
                TitleText.titleText(
                  "Trạng thái",
                  wrapWords('${area['status']}', 35),
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
