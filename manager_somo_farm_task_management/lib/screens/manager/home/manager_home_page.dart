import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/task.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/add_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/home/components/task_tile.dart';
import 'package:manager_somo_farm_task_management/services/notification_services.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/bottom_navigation_bar.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({Key? key}) : super(key: key);

  @override
  ManagerHomePageState createState() => ManagerHomePageState();
}

class ManagerHomePageState extends State<ManagerHomePage> {
  int _currentIndex = 0;
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu định dạng cho ngôn ngữ Việt Nam
    initializeDateFormatting('vi_VN', null);
    //notifyHelper = NotifyHelper();
    //notifyHelper.initializeNotification();
  }

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
                        builder: (context) => const AddTaskPage(),
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
              if (task.repeat == 'Daily') {
                // DateTime date =
                //     DateFormat.jm().parseLoose(task.startTime.toString());
                // var myTime = DateFormat("HH:mm").format(date);
                // // notifyHelper.scheduledNotification(
                // //   int.parse(myTime.toString().split(":")[0]),
                // //   int.parse(myTime.toString().split(":")[1]),
                // //   task,
                // // );
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
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
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
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
          height: task.isCompleted == 1
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
              task.isCompleted == 1
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
                  Navigator.of(context).pop();
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
