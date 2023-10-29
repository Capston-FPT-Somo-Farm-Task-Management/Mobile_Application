import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task/sub_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/time_keeping/time_keeping_task_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoneTaskEmployeePage extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  DateTime? startDate;
  DateTime? endDate;
  DoneTaskEmployeePage(
      {Key? key,
      required this.employeeId,
      this.startDate,
      this.endDate,
      required this.employeeName})
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
  bool isLoadingMore = false;
  int page = 1;
  final scrollController = ScrollController();
  int groupValue = 2;
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await getTask(groupValue, false);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  initState() {
    super.initState();
    selectedFilter = filters[0];
    getTask(2, true);
    getRole();
    scrollController.addListener(() {
      _scrollListener();
    });
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

  Future<void> getTask(int status, bool reset) async {
    await TaskService()
        .getTasksByDateEmployeeId(widget.employeeId, widget.startDate,
            widget.endDate, 1, page, status)
        .then((value) {
      if (reset) {
        setState(() {
          tasks = value;
          filteredTaskList = value;
          isLoading = false;
        });
      } else {
        setState(() {
          tasks = tasks + value;
          filteredTaskList = value;
          isLoading = false;
        });
      }
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.employeeName,
                    style: headingStyle,
                  ),
                  const SizedBox(height: 25),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CupertinoSegmentedControl<int>(
                            selectedColor: kSecondColor,
                            borderColor: kSecondColor,
                            pressedColor: Colors.blue[50],
                            children: {
                              2: Text("Hoàn thành"),
                              3: Text("Không hoàn thành"),
                              // Thêm các option khác nếu cần
                            },
                            onValueChanged: (int newValue) {
                              setState(() {
                                groupValue = newValue;
                                isLoading = true;
                              });
                              getTask(groupValue, true);
                            },
                            groupValue: groupValue,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            onRefresh: () => getTask(groupValue, true),
                            child: ListView.separated(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: isLoadingMore
                                  ? filteredTaskList.length + 1
                                  : filteredTaskList.length,
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
                                    onLongPress: () {
                                      _showBottomSheet(context, task);
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
                                                            Flexible(
                                                              child: Text(
                                                                task['name'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
                                                          Flexible(
                                                            child: Text(
                                                              "${DateFormat('HH:mm  dd/MM/yy').format(DateTime.parse(task['startDate']))}  -  ${DateFormat('HH:mm  dd/MM/yy').format(DateTime.parse(task['endDate']))}",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                          Flexible(
                                                            child: Text(
                                                              "Giờ làm thực tế (cá nhân): ${task['effort']} giờ",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              "Giám sát: ${task['supervisorName']}",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              "Vị trí: ${task['fieldName']}",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                Flexible(
                                                  child: Text(
                                                    'Loại: ${task['taskTypeName']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.grey[200]),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    'Ưu tiên: ${task['priority']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.grey[200]),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
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

  _showBottomSheet(
    BuildContext context,
    Map<String, dynamic> task,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        bool isCompleted = task['status'] == "Hoàn thành";
        bool isNotCompleted = task['status'] == "Không hoàn thành";

        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.25,
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
              if (isCompleted || isNotCompleted)
                _bottomSheetButton(
                  label: "Xem chấm công",
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TimeKeepingInTask(
                          taskId: task['id'],
                          taskName: task['name'],
                          isCreate: false,
                          status: 0,
                        ),
                      ),
                    );
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
