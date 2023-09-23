import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/task.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/choose_habitant.dart';
import 'package:manager_somo_farm_task_management/screens/manager/home/components/task_tile.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_details/task_details_popup.dart';
import 'package:manager_somo_farm_task_management/services/notification_services.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/bottom_navigation_bar.dart';

class ManagerHomePage extends StatefulWidget {
  final int farmId;
  const ManagerHomePage({Key? key, required this.farmId}) : super(key: key);

  @override
  ManagerHomePageState createState() => ManagerHomePageState();
}

class ManagerHomePageState extends State<ManagerHomePage> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu định dạng cho ngôn ngữ Việt Nam
    initializeDateFormatting('vi_VN', null);
    notificationService.initialNotification();
  }

  NotificationService notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {
    // Tiếp tục với mã widget của bạn như trước
    var vietnameseDate = DateFormat.yMMMMd('vi_VN').format(DateTime.now());

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vietnameseDate,
                      style: subHeadingStyle,
                    ),
                    Text(
                      "Hôm nay",
                      style: headingStyle.copyWith(color: kSecondColor),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            // FirstAddTaskPage(farm: widget.farm),
                            ChooseHabitantPage(farmId: widget.farmId),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kPrimaryColor,
                    ),
                    alignment: Alignment
                        .center, // Đặt alignment thành Alignment.center
                    child: const Text(
                      "+ Thêm việc",
                      style: TextStyle(
                        color: kTextWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: kPrimaryColor,
              selectedTextColor: kTextWhiteColor,
              dateTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              locale: 'vi_VN',
            ),
          ),
          const SizedBox(height: 10),
          _showTask(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  _showTask() {
    return Expanded(
        child: ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (_, index) {
              Task task = taskList[index];
              if (task.remind != 0) {
                notificationService.scheduleNotification(task);
              }
              if (task.repeat == 1) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskDetailsPopup(task: task);
                                },
                              );
                            },
                            onLongPress: () {
                              _showBottomSheet(context, taskList[index]);
                            },
                            child: TaskTile(taskList[index]),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (task.startDate.isBefore(_selectedDate) &&
                      task.endDate.isAfter(_selectedDate) ||
                  DateFormat.yMd().format(task.startDate) ==
                      DateFormat.yMd().format(_selectedDate) ||
                  DateFormat.yMd().format(task.endDate) ==
                      DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskDetailsPopup(task: task);
                                },
                              );
                            },
                            onLongPress: () {
                              _showBottomSheet(context, taskList[index]);
                            },
                            child: TaskTile(taskList[index]),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.status == 3
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.32,
          color: kBackgroundColor,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kTextGreyColor,
                ),
              ),
              const Spacer(),
              task.status == 3
                  ? Container()
                  : _bottomSheetButton(
                      label: "Đã hoàn thành",
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      cls: kPrimaryColor,
                      context: context,
                    ),
              _bottomSheetButton(
                label: "Xóa",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Xóa công việc",
                          content: "Bạn có chắc muốn xóa công việc này?",
                          onConfirm: () {
                            Navigator.of(context).pop();
                          },
                          buttonConfirmText: "Xóa",
                        );
                      });
                },
                cls: Colors.red[300]!,
                context: context,
              ),
              const SizedBox(height: 20),
              _bottomSheetButton(
                label: "Đóng",
                onTap: () {
                  Navigator.of(context).pop();
                },
                cls: Colors.white,
                isClose: true,
                context: context,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color cls,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.grey[300]! : cls,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : cls,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titileStyle
                : titileStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
