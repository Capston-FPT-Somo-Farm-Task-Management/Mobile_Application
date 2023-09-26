import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/livestock.dart';
import 'package:manager_somo_farm_task_management/models/plant.dart';

class LiveStockDetailsPopup extends StatelessWidget {
  final LiveStock liveStock;

  const LiveStockDetailsPopup({required this.liveStock});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            liveStock.name,
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
                ),
                const SizedBox(width: 8),
                Text(
                  'Mã động vật: ${liveStock.id}',
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
                  FontAwesomeIcons.paw,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Loại động vật: ${liveStock.type}',
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
                  'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(liveStock.createDate)}',
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
                  FontAwesomeIcons.horseHead,
                  color: kSecondColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Số lượng: ${liveStock.quantity}',
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
