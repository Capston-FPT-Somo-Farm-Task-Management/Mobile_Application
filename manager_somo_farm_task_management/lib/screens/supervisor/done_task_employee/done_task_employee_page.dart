import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task/sub_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoneTaskEmployeePage extends StatefulWidget {
  final int employeeId;
  DateTime? startDate;
  DateTime? endDate;
  DoneTaskEmployeePage(
      {Key? key, required this.employeeId, this.startDate, this.endDate})
      : super(key: key);

  @override
  DoneTaskEmployeePageState createState() => DoneTaskEmployeePageState();
}

class DoneTaskEmployeePageState extends State<DoneTaskEmployeePage> {
  final List<String> filters = [
    "Tất cả",
    "Hoàn thành",
    "Không hoàn thành",
  ];
  String? role;
  String? selectedFilter;
  int? farmId;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTaskList = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    selectedFilter = filters[0];
    getTask();
    getRole();
  }

  void searchTasks(String keyword) {
    setState(() {
      filteredTaskList = tasks
          .where((task) => removeDiacritics(task['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  Future<void> getTask() async {
    await TaskService()
        .getTasksByDateEmployeeId(
            widget.employeeId, widget.startDate, widget.endDate)
        .then((value) {
      setState(() {
        tasks = value;
        filteredTaskList = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close_sharp, color: kSecondColor)),
        title: Text("Các công việc đã làm",
            style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    height: 42,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (keyword) {
                          searchTasks(keyword.trim());
                        },
                        decoration: const InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          value:
                              selectedFilter, // Giá trị đã chọn cho Dropdown 1
                          onChanged: (newValue) {
                            setState(() {
                              selectedFilter =
                                  newValue; // Cập nhật giá trị đã chọn cho Dropdown 1
                              if (selectedFilter == "Tất cả") {
                                filteredTaskList = tasks;
                              }
                              if (selectedFilter == "Hoàn thành") {
                                filteredTaskList = tasks
                                    .where((t) => t['status'] == "Hoàn thành")
                                    .toList();
                              }
                              if (selectedFilter == "Không hoàn thành") {
                                filteredTaskList = tasks
                                    .where((t) =>
                                        t['status'] == "Không hoàn thành")
                                    .toList();
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : filteredTaskList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_backpack,
                                size:
                                    75, // Kích thước biểu tượng có thể điều chỉnh
                                color: Colors.grey, // Màu của biểu tượng
                              ),
                              SizedBox(
                                  height:
                                      16), // Khoảng cách giữa biểu tượng và văn bản
                              Text(
                                "Không có công việc nào",
                                style: TextStyle(
                                  fontSize:
                                      20, // Kích thước văn bản có thể điều chỉnh
                                  color: Colors.grey, // Màu văn bản
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: RefreshIndicator(
                            notificationPredicate: (_) => true,
                            onRefresh: () => getTask(),
                            child: ListView.separated(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: filteredTaskList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 20);
                              },
                              itemBuilder: (context, index) {
                                if (index < filteredTaskList.length) {
                                  final task = filteredTaskList[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => TaskDetailsPage(
                                              taskId: task['id']),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 10,
                                            offset:
                                                Offset(1, 4), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              wrapWordsWithEllipsis(
                                                                  task['name'],
                                                                  20),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Priority
                                                                      .getBGClr(
                                                                          task[
                                                                              'priority']),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                        builder: (context) => SubTaskPage(
                                                                            taskId:
                                                                                task['id'],
                                                                            taskName: task['name']),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                    size: 15,
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                        if (role == "Manager" &&
                                                                task['managerName'] ==
                                                                    null ||
                                                            role == "Supervisor" &&
                                                                task['managerName'] !=
                                                                    null)
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            alignment: Alignment
                                                                .topRight,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        35),
                                                            child: Tooltip(
                                                              message: role ==
                                                                      "Manager"
                                                                  ? 'Công việc do người giám sát tạo'
                                                                  : 'Công việc do người quản lí tạo',
                                                              child: Icon(
                                                                Icons
                                                                    .account_circle_rounded,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                          ),
                                                      ]),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .access_time_rounded,
                                                            color: Colors.black,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            "${DateFormat('HH:mm  dd/MM/yy').format(DateTime.parse(task['startDate']))}  -  ${DateFormat('HH:mm  dd/MM/yy').format(DateTime.parse(task['endDate']))}",
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Giám sát: ${task['supervisorName']}",
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Vị trí: ${task['fieldName']}",
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
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
                                              color: Priority.getBGClr(task[
                                                  'priority']), // Đặt màu xám ở đây
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            height: 45,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Loại: ${task['taskTypeName']}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[200]),
                                                ),
                                                Text(
                                                  'Ưu tiên: ${task['priority']}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[200]),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: kPrimaryColor),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
