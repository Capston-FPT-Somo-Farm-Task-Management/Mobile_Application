import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_add/choose_habitant.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_details/task_details_popup.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/bottom_navigation_bar.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  int _currentIndex = 0;
  final List<String> filters = [
    "Tất cả",
    "Chuẩn bị",
    "Hoàn thành",
    "Đang thực hiện",
    "Không hoàn thành",
  ];

  String? selectedFilter;
  String selectedDate = "";

  int? farmId;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTaskList = [];
  @override
  initState() {
    super.initState();
    selectedFilter = filters[0];
    getFarmId().then((value) {
      farmId = value;
    });
    getTasks();
  }

  Future<bool> changeTaskStatus(int taskId, int newStatus) async {
    return TaskService().changeTaskStatus(taskId, newStatus);
  }

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  void searchTasks(String keyword) {
    setState(() {
      filteredTaskList = tasks
          .where((task) => removeDiacritics(task['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    TaskService().getTaskActiveByUserId(userId!).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          tasks = value;
          filteredTaskList = tasks;
        });
      } else {
        throw Exception();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Công việc",
                    style: TextStyle(
                      fontSize: 28, // Thay đổi kích thước phù hợp
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  // FirstAddTaskPage(farm: widget.farm),
                                  ChooseHabitantPage(farmId: farmId!),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          minimumSize: Size(120, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Thêm việc",
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Khoảng cách giữa hai nút
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 42,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (keyword) {
                        searchTasks(keyword);
                      },
                      decoration: const InputDecoration(
                        hintText: "Tìm kiếm...",
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(selectedDate),
                    IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        DateTime? _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1),
                          lastDate: DateTime(9000),
                        );

                        setState(() {
                          if (_selectedDate != null) {
                            filteredTaskList = tasks
                                .where((task) =>
                                    DateTime.parse(task['startDate'])
                                            .isBefore(_selectedDate) &&
                                        DateTime.parse(task['endDate'])
                                            .isAfter(_selectedDate) ||
                                    DateFormat.yMd().format(DateTime.parse(
                                            task['startDate'])) ==
                                        DateFormat.yMd()
                                            .format(_selectedDate) ||
                                    DateFormat.yMd().format(
                                            DateTime.parse(task['endDate'])) ==
                                        DateFormat.yMd().format(_selectedDate))
                                .toList();
                            selectedDate =
                                DateFormat('dd/MM/yy').format(_selectedDate);
                          } else {
                            setState(() {
                              selectedDate = "";
                              filteredTaskList = tasks;
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Màu đường viền
                          width: 1.0, // Độ rộng của đường viền
                        ),
                        borderRadius: BorderRadius.circular(
                            5.0), // Độ bo góc của đường viền
                      ),
                      child: DropdownButton<String>(
                        isDense: true,
                        alignment: Alignment.center,
                        hint: Text(selectedFilter!),
                        value: selectedFilter, // Giá trị đã chọn cho Dropdown 1
                        onChanged: (newValue) {
                          setState(() {
                            selectedFilter =
                                newValue; // Cập nhật giá trị đã chọn cho Dropdown 1
                            if (selectedFilter == "Tất cả") {
                              // Nếu đã chọn "Tất cả", hiển thị tất cả các nhiệm vụ
                              filteredTaskList = tasks;
                              selectedDate = "";
                            }
                            if (selectedFilter == "Không hoàn thành") {
                              filteredTaskList = tasks
                                  .where(
                                      (t) => t['status'] == "Không hoàn thành")
                                  .toList();
                              selectedDate = "";
                            }
                            if (selectedFilter == "Đang thực hiện") {
                              filteredTaskList = tasks
                                  .where((t) => t['status'] == "Đang thực hiện")
                                  .toList();
                              selectedDate = "";
                            }
                            if (selectedFilter == "Hoàn thành") {
                              filteredTaskList = tasks
                                  .where((t) => t['status'] == "Hoàn thành")
                                  .toList();
                              selectedDate = "";
                            }
                            if (selectedFilter == "Chuẩn bị") {
                              filteredTaskList = tasks
                                  .where((t) => t['status'] == "Chuẩn bị")
                                  .toList();
                              selectedDate = "";
                            }
                          });
                        },
                        items: filters
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: ListView.separated(
                itemCount: filteredTaskList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 25);
                },
                itemBuilder: (context, index) {
                  final task = filteredTaskList[index];

                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TaskDetailsPopup(task: task);
                        },
                      );
                    },
                    onLongPress: () {
                      _showBottomSheet(context, task);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 7,
                            offset: Offset(4, 8), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey, // Màu của đường viền
                                width: 1.0, // Độ dày của đường viền
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            task['name'].length > 15
                                                ? '${task['name'].substring(0, 15)}...'
                                                : task['name'],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: task['status'] ==
                                                      "Không hoàn thành"
                                                  ? Colors.red[400]
                                                  : task['status'] == "Chuẩn bị"
                                                      ? Colors.orange[400]
                                                      : task['status'] ==
                                                              "Đang thực hiện"
                                                          ? kTextBlueColor
                                                          : kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              task['status'],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.access_time_rounded,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${DateFormat('HH:mm  dd/MM/yy').format(DateTime.parse(task['startDate']))}  -  ${DateFormat('HH:mm  dd/MM/yy').format(DateTime.parse(task['endDate']))}",
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Giám sát: ${task['receiverName']}",
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Text(
                                            "Vị trí: ${task['fieldName']}",
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[400], // Đặt màu xám ở đây
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Loại: ${task['taskTypeName']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Ưu tiên: ${task['priority']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

  _showBottomSheet(BuildContext context, Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: task['status'] != "Hoàn thành"
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
              if (task['status'] == "Hoàn thành")
                _bottomSheetButton(
                  label: "Xem bằng chứng",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  cls: kPrimaryColor,
                  context: context,
                ),
              if (task['status'] == "Hoàn thành")
                _bottomSheetButton(
                  label: "Đánh giá",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  cls: kPrimaryColor,
                  context: context,
                ),
              if (task['status'] == "Không hoàn thành")
                _bottomSheetButton(
                  label: "Đánh giá",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  cls: kPrimaryColor,
                  context: context,
                ),
              if (task['status'] == "Chuẩn bị")
                _bottomSheetButton(
                  label: "Xóa",
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context1) {
                          return ConfirmDeleteDialog(
                            title: "Xóa công việc",
                            content: "Bạn có chắc muốn xóa công việc này?",
                            onConfirm: () {
                              changeTaskStatus(task['id'], 4).then((value) {
                                if (value) {
                                  getTasks();
                                  Navigator.of(context).pop();
                                  SnackbarShowNoti.showSnackbar(
                                      context, "Xóa thành công!", false);
                                } else {
                                  SnackbarShowNoti.showSnackbar(
                                      context, "Xảy ra lỗi!", true);
                                }
                              });
                            },
                            buttonConfirmText: "Xóa",
                          );
                        });
                  },
                  cls: Colors.red[300]!,
                  context: context,
                ),
              if (task['status'] == "Đang thực hiện")
                _bottomSheetButton(
                  label: "Hoàn thành",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  cls: kPrimaryColor,
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
