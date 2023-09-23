import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/models/task.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/choose_habitant.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_details/task_details_popup.dart';
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
    "Đang làm",
    "Hoàn thành",
    "Không hoàn thành",
  ];
  List<Task> filteredTaskList = taskList;
  String? selectedFilter;
  bool sortOrderAsc = true;

  int? farmId;
  final TextEditingController searchController = TextEditingController();
  @override
  initState() {
    super.initState();
    selectedFilter = filters[0];
    getFarmId();
  }

  Future<void> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');

    setState(() {
      farmId = storedFarmId;
    });
  }

  void searchTasks(String keyword) {
    setState(() {
      filteredTaskList = taskList
          .where((task) => removeDiacritics(task.name.toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
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
                  child: Expanded(
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
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () {
                        setState(() {
                          if (sortOrderAsc) {
                            // Sắp xếp tăng dần (ngày gần đến xa)
                            filteredTaskList.sort(
                                (a, b) => a.startDate.compareTo(b.startDate));
                            sortOrderAsc = false;
                          } else {
                            // Sắp xếp giảm dần (ngày xa đến gần)
                            filteredTaskList.sort(
                                (a, b) => b.startDate.compareTo(a.startDate));
                            sortOrderAsc = true;
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
                              filteredTaskList = taskList;
                            }
                            if (selectedFilter == "Không hoàn thành") {
                              filteredTaskList =
                                  taskList.where((t) => t.status == 1).toList();
                            }
                            if (selectedFilter == "Đang làm") {
                              filteredTaskList =
                                  taskList.where((t) => t.status == 2).toList();
                            }
                            if (selectedFilter == "Hoàn thành") {
                              filteredTaskList =
                                  taskList.where((t) => t.status == 3).toList();
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
                                            task.name.length > 15
                                                ? '${task.name.substring(0, 15)}...'
                                                : task.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: task.status == 1
                                                  ? Colors.red
                                                  : task.status == 2
                                                      ? Colors.orange
                                                      : kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              Task.getStatus(task.status),
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
                                            "${DateFormat('dd/MM HH:mm').format(task.startDate)} - ${DateFormat('dd/MM HH:mm').format(task.endDate)}",
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
                                            "Giám sát: ${task.supervisorId.toString()}",
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Text(
                                            "Vị trí: ${task.fieldId.toString()}",
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
                                  'Loại: ${task.taskTypeId}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Ưu tiên: ${Priority.getPriority(task.priority)}',
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
