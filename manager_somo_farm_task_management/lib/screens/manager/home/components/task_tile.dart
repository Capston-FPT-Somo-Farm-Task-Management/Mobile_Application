import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/screens/manager/sub_task/sub_task_page.dart';

class TaskTile extends StatelessWidget {
  final Map<String, dynamic> task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 5, 16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Priority.getBGClr(task['priority']),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task['name'].length > 20
                          ? '${task['name'].substring(0, 20)}...'
                          : task['name'],
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      task['priority'],
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${DateFormat('HH:mm aa  dd/MM').format(DateTime.parse(task['startDate']))}  -  ${DateFormat('HH:mm aa dd/MM').format(DateTime.parse(task['endDate']))}",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 13, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Giám sát: ${task['receiverName']}",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.grey[100]),
                      ),
                    ),
                    Text(
                      "Vị trí: ${task['fieldName'].length > 19 ? task['fieldName'].substring(0, 18) + '...' : task['fieldName']}",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      SubTaskPage(taskId: task['id'], taskName: task['name']),
                ),
              );
            },
            child: RotatedBox(
              quarterTurns: 0,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: kBackgroundColor,
                  size: 12,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
