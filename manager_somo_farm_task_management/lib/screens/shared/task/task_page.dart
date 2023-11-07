import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task/sub_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/choose_habitant.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/rejection_reason/rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/time_keeping/time_keeping_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/view_rejection_reason/view_rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/app_bar.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  final List<String> filters = [
    "Tất cả",
    "Chuẩn bị",
    "Hoàn thành",
    "Đang thực hiện",
    "Không hoàn thành",
  ];

  String? selectedFilter;
  String selectedDate = "";
  DateTime? _selectedDate;
  int? farmId;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTaskList = [];
  bool isLoading = true;
  int groupValue = 0;
  bool isMoreLeft = false;
  String? role;
  int page = 1;
  bool isLoadingMore = false;
  String searchValue = "";
  final scrollController = ScrollController();
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await _getTasksForSelectedDateAndStatus(
          page, 10, _selectedDate, groupValue, false, searchValue);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<bool> cancelRejectTaskStatus(int taskId) async {
    return TaskService().cancelRejectTaskStatus(taskId);
  }

  void removeTask(int taskId) {
    setState(() {
      tasks.removeWhere((task) => task['id'] == taskId);
    });
  }

  Future<bool> deleteTask(int taskId) async {
    return TaskService().deleteTask(taskId);
  }

  @override
  initState() {
    super.initState();
    selectedFilter = filters[0];
    getFarmId().then((value) {
      farmId = value;
    });
    getRole().then((_) {
      _getTasksForSelectedDateAndStatus(page, 10, null, 0, true, "");
    });
    scrollController.addListener(() {
      _scrollListener();
    });
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
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

  Future<void> _getTasksForSelectedDateAndStatus(int index, int pageSize,
      DateTime? selectedDate, int status, bool reset, String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    List<Map<String, dynamic>> selectedDateTasks;
    if (role == "Manager") {
      selectedDateTasks = await TaskService().getTasksByManagerIdDateStatus(
          index, pageSize, userId!, selectedDate, status, search);
    } else {
      selectedDateTasks = await TaskService().getTasksBySupervisorIdDateStatus(
          index, pageSize, userId!, selectedDate, status, search);
    }
    if (reset) {
      setState(() {
        tasks = selectedDateTasks;
        isLoading = false;
        filteredTaskList = tasks;
      });
    } else {
      setState(() {
        tasks = tasks + selectedDateTasks;
        isLoading = false;
        filteredTaskList = tasks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ],
                  ),
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
                          setState(() {
                            searchValue = keyword.trim();
                          });
                          ;
                          _getTasksForSelectedDateAndStatus(
                              1, 10, null, groupValue, true, searchValue);
                        },
                        decoration: const InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!selectedDate.isEmpty)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                              _selectedDate = null;
                              selectedDate = "";
                            });
                            _getTasksForSelectedDateAndStatus(
                                1, 10, null, groupValue, true, searchValue);
                          },
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      SizedBox(width: 10),
                      Text(selectedDate),
                      IconButton(
                        icon: const Icon(Icons.calendar_month_outlined),
                        onPressed: () async {
                          DateTime? _selected = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1),
                            lastDate: DateTime(9000),
                          );

                          setState(() {
                            if (_selected != null) {
                              _getTasksForSelectedDateAndStatus(1, 10,
                                  _selected, groupValue, true, searchValue);
                              selectedDate =
                                  DateFormat('dd/MM/yy').format(_selected);
                              _selectedDate = _selected;
                            } else {
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, null, groupValue, true, searchValue);
                              setState(() {
                                selectedDate = "";
                                filteredTaskList = tasks;
                              });
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: !isMoreLeft
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CupertinoSegmentedControl<int>(
                            selectedColor: kSecondColor,
                            borderColor: kSecondColor,
                            pressedColor: Colors.blue[50],
                            children: {
                              5: Text("Từ chối"),
                              0: Text("Chuẩn bị"),
                              1: Text("Đang làm"),
                              2: Text(">>>")
                              // Thêm các option khác nếu cần
                            },
                            onValueChanged: (int newValue) {
                              setState(() {
                                isLoading = true;
                              });
                              if (newValue == 2)
                                setState(() {
                                  isMoreLeft = true;
                                });

                              setState(() {
                                groupValue = newValue;
                              });
                              _getTasksForSelectedDateAndStatus(1, 10,
                                  _selectedDate, groupValue, true, searchValue);
                            },
                            groupValue: groupValue,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CupertinoSegmentedControl<int>(
                            selectedColor: kSecondColor,
                            borderColor: kSecondColor,
                            pressedColor: Colors.blue[50],
                            children: {
                              0: Text("<<<"),
                              1: Text('Đang làm'),
                              2: Text('Hoàn thành'),
                              3: Text(' Không h.thành '),

                              // Thêm các option khác nếu cần
                            },
                            onValueChanged: (int newValue) {
                              setState(() {
                                isLoading = true;
                              });
                              if (newValue == 0)
                                setState(() {
                                  isMoreLeft = false;
                                });

                              setState(() {
                                groupValue = newValue;
                              });
                              _getTasksForSelectedDateAndStatus(1, 10,
                                  _selectedDate, groupValue, true, searchValue);
                            },
                            groupValue: groupValue,
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
                            onRefresh: () => _getTasksForSelectedDateAndStatus(
                                1,
                                10,
                                _selectedDate,
                                groupValue,
                                true,
                                searchValue),
                            child: ListView.separated(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: scrollController,
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
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => TaskDetailsPage(
                                              taskId: task['id']),
                                        ),
                                      )
                                          .then((value) {
                                        if (value != null)
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                      });
                                    },
                                    onLongPress: () {
                                      _showBottomSheet(
                                          context, task, _selectedDate, role!);
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
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              "#CV23001",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic, // Chữ in nghiêng
                                                                  color: Priority
                                                                      .getBGClr(
                                                                          task[
                                                                              'priority']),
                                                                ),
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
                                                      Stack(children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .access_time_rounded,
                                                              color: Colors
                                                                  .black87,
                                                              size: 18,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Flexible(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          'Bắt đầu: ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          '${DateFormat('dd/MM/yyyy   HH:mm aa').format(DateTime.parse(task['startDate']))}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (task[
                                                            'isHaveEvidence'])
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
                                                                        0),
                                                            child: Tooltip(
                                                              message:
                                                                  "Có báo cáo",
                                                              child: Icon(
                                                                Icons
                                                                    .barcode_reader,
                                                                color: Colors
                                                                    .black54,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                      ]),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .access_time_rounded,
                                                            color:
                                                                Colors.black87,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Flexible(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Kết thúc: ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '${DateFormat('dd/MM/yyyy   HH:mm aa').format(DateTime.parse(task['endDate']))}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 30),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Giám sát: ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '${task['supervisorName']}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Vị trí: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '${task['fieldName']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Loại: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '${task['taskTypeName']}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Ưu tiên: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[200],
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${task['priority']}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[200],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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

  _showBottomSheet(BuildContext context, Map<String, dynamic> task,
      DateTime? _selectedDate, String role) {
    role == "Manager"
        ? showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              bool isRejected = task['status'] == "Từ chối";
              bool isPreparing = task['status'] == "Chuẩn bị";
              bool isExecuting = task['status'] == "Đang thực hiện";
              bool isCompleted = task['status'] == "Hoàn thành";
              bool isNotCompleted = task['status'] == "Không hoàn thành";

              return Container(
                padding: const EdgeInsets.only(top: 4),
                height: isRejected || isCompleted
                    ? MediaQuery.of(context).size.height * 0.35
                    : isExecuting
                        ? MediaQuery.of(context).size.height * 0.23
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
                    if (isPreparing ||
                        isExecuting ||
                        isCompleted ||
                        isNotCompleted)
                      _bottomSheetButton(
                        label: "Xem báo cáo",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EvidencePage(
                                task: task,
                                role: role,
                              ),
                            ),
                          );
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isRejected)
                      _bottomSheetButton(
                        label: "Xem báo cáo",
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ViewRejectionReasonPopup(
                                task: task,
                                role: role,
                              );
                            },
                          ).then((value) =>
                              {if (value != null) removeTask(task['id'])});
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isRejected)
                      _bottomSheetButton(
                        label: "Chỉnh sửa",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateTaskPage(
                                task: task,
                                role: role,
                              ),
                            ),
                          );
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isRejected)
                      _bottomSheetButton(
                        label: "Không chấp nhận",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Không chấp nhận từ chối",
                                content:
                                    'Công việc sẽ chuyển sang trạng thái "Chuẩn bị"',
                                onConfirm: () {
                                  Navigator.of(context).pop();
                                  cancelRejectTaskStatus(task['id'])
                                      .then((value) {
                                    if (value) {
                                      removeTask(task['id']);
                                      SnackbarShowNoti.showSnackbar(
                                          "Đổi thành công!", false);
                                    } else {
                                      SnackbarShowNoti.showSnackbar(
                                          "Xảy ra lỗi!", true);
                                    }
                                  });
                                },
                                buttonConfirmText: "Đồng ý",
                              );
                            },
                          );
                        },
                        cls: Colors.red[300]!,
                        context: context,
                      ),
                    if (isPreparing)
                      _bottomSheetButton(
                        label: "Hủy / Xóa",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Xóa công việc",
                                content: "Bạn có chắc muốn xóa công việc này?",
                                onConfirm: () {
                                  Navigator.of(context).pop();
                                  deleteTask(task['id']).then((value) {
                                    if (value) {
                                      removeTask(task['id']);
                                      SnackbarShowNoti.showSnackbar(
                                          "Xóa thành công!", false);
                                    } else {
                                      SnackbarShowNoti.showSnackbar(
                                          "Xảy ra lỗi!", true);
                                    }
                                  });
                                },
                                buttonConfirmText: "Xóa",
                              );
                            },
                          );
                        },
                        cls: Colors.red[300]!,
                        context: context,
                      ),
                    if (isCompleted)
                      _bottomSheetButton(
                        label: "Đánh giá",
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isCompleted || isNotCompleted)
                      _bottomSheetButton(
                        label: "Chấm công",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TimeKeepingInTask(
                                taskId: task['id'],
                                taskName: task['name'],
                                isCreate: false,
                                status: 0,
                                endDateTask: task['endDate'],
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
          )
        : showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              bool isRejected = task['status'] == "Từ chối";
              bool isPreparing = task['status'] == "Chuẩn bị";
              bool isExecuting = task['status'] == "Đang thực hiện";
              bool isCompleted = task['status'] == "Hoàn thành";
              bool isNotCompleted = task['status'] == "Không hoàn thành";

              return Container(
                padding: const EdgeInsets.only(top: 4),
                height: isRejected ||
                        isCompleted ||
                        isNotCompleted ||
                        isPreparing &&
                            DateTime.now()
                                .add(Duration(minutes: 30))
                                .isAfter(DateTime.parse(task['startDate'])) &&
                            task['managerName'] != null
                    ? MediaQuery.of(context).size.height * 0.30
                    : MediaQuery.of(context).size.height * 0.38,
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
                    if (isPreparing ||
                        isExecuting ||
                        isCompleted ||
                        isNotCompleted)
                      _bottomSheetButton(
                        label: "Báo cáo",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EvidencePage(
                                role: role,
                                task: task,
                              ),
                            ),
                          );
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isRejected)
                      _bottomSheetButton(
                        label: "Xem báo cáo",
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ViewRejectionReasonPopup(
                                task: task,
                                role: role,
                              );
                            },
                          ).then((value) => {
                                if (value != null) {removeTask(task['id'])}
                              });
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isRejected)
                      _bottomSheetButton(
                        label: "Hủy từ chối",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Hủy từ chối",
                                content:
                                    'Công việc sẽ chuyển sang trạng thái "Chuẩn bị"',
                                onConfirm: () {
                                  Navigator.of(context).pop();
                                  cancelRejectTaskStatus(task['id'])
                                      .then((value) {
                                    if (value) {
                                      removeTask(task['id']);
                                      SnackbarShowNoti.showSnackbar(
                                          "Đổi thành công!", false);
                                    } else {
                                      SnackbarShowNoti.showSnackbar(
                                          "Xảy ra lỗi!", true);
                                    }
                                  });
                                },
                                buttonConfirmText: "Đồng ý",
                              );
                            },
                          );
                        },
                        cls: Colors.red[300]!,
                        context: context,
                      ),
                    if (isPreparing)
                      _bottomSheetButton(
                        label: "Đang thực hiện",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Đổi trạng thái",
                                content:
                                    'Chuyển công việc sang "Đang thực hiện"',
                                onConfirm: () {
                                  Navigator.of(context).pop();
                                  changeTaskStatus(task['id'], 1).then((value) {
                                    if (value) {
                                      removeTask(task['id']);
                                      SnackbarShowNoti.showSnackbar(
                                          "Đổi thành công!", false);
                                    } else {
                                      SnackbarShowNoti.showSnackbar(
                                          "Xảy ra lỗi!", true);
                                    }
                                  });
                                },
                                buttonConfirmText: "Đồng ý",
                              );
                            },
                          );
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isPreparing && task['managerName'] == null)
                      _bottomSheetButton(
                        label: "Hủy / Xóa",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Xóa công việc",
                                content: "Bạn có chắc muốn xóa công việc này?",
                                onConfirm: () {
                                  deleteTask(task['id']).then((value) {
                                    if (value) {
                                      removeTask(task['id']);
                                      Navigator.of(context).pop();
                                      SnackbarShowNoti.showSnackbar(
                                          "Xóa thành công!", false);
                                    } else {
                                      SnackbarShowNoti.showSnackbar(
                                          "Xảy ra lỗi!", true);
                                    }
                                  });
                                },
                                buttonConfirmText: "Xóa",
                              );
                            },
                          );
                        },
                        cls: Colors.red[300]!,
                        context: context,
                      ),
                    if (isPreparing &&
                        task['managerName'] != null &&
                        DateTime.now()
                            .add(Duration(minutes: 30))
                            .isBefore(DateTime.parse(task['startDate'])))
                      _bottomSheetButton(
                        label: "Từ chối",
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RejectionReasonPopup(
                                taskId: task['id'],
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              removeTask(task['id']);
                            }
                          });
                        },
                        cls: Colors.red[300]!,
                        context: context,
                      ),
                    if (isExecuting)
                      _bottomSheetButton(
                        label: "Hoàn thành",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => TimeKeepingInTask(
                                    taskId: task['id'],
                                    taskName: task['name'],
                                    isCreate: true,
                                    status: 2,
                                    endDateTask: task['endDate'],
                                  ),
                                ),
                              )
                              .then((value) => {
                                    if (value != null) {removeTask(task['id'])}
                                  });
                        },
                        cls: kPrimaryColor,
                        context: context,
                      ),
                    if (isExecuting)
                      _bottomSheetButton(
                        label: "Không hoàn thành",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => TimeKeepingInTask(
                                    taskId: task['id'],
                                    taskName: task['name'],
                                    isCreate: true,
                                    status: 3,
                                    endDateTask: task['endDate'],
                                  ),
                                ),
                              )
                              .then((value) => {
                                    if (value != null) {removeTask(task['id'])}
                                  });
                        },
                        cls: Colors.red[300]!,
                        context: context,
                      ),
                    if (isCompleted || isNotCompleted)
                      _bottomSheetButton(
                        label: "Chấm công",
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TimeKeepingInTask(
                                taskId: task['id'],
                                taskName: task['name'],
                                isCreate: false,
                                status: 0,
                                endDateTask: task['endDate'],
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
