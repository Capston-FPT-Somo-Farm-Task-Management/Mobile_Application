import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/explosion.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task/sub_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/components/icon_option.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/time_keeping/time_keeping_task_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoneTaskEmployeePage extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  final DateTime? startDate;
  final DateTime? endDate;
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
  int? selectedStatus;
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await getTask(false, 10);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  List<String> statuss = ["Tất cả", "Đã đóng", "Đã hủy"];
  @override
  initState() {
    super.initState();
    selectedFilter = statuss[0];
    getTask(true, 10);
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

  Future<void> getTask(bool reset, int pageSize) async {
    await TaskService()
        .getTasksDoneByDateEmployeeId(widget.employeeId, widget.startDate,
            widget.endDate, 1, pageSize, selectedStatus)
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
              child: Text(
                widget.employeeName,
                style: headingStyle,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isDense: true,
                      alignment: Alignment.center,
                      onChanged: (newValue) {
                        setState(() {
                          selectedFilter = newValue;
                          selectedStatus = newValue == "Tất cả"
                              ? null
                              : newValue == "Đã đóng"
                                  ? 8
                                  : 7;
                          getTask(true, 10);
                        });
                      },
                      items: statuss.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: RefreshIndicator(
                            notificationPredicate: (_) => true,
                            onRefresh: () => getTask(true, 10),
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
                                          getTask(true, 10 * page);
                                      });
                                    },
                                    onLongPress: () {
                                      _showBottomSheet(context, task, role!);
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
                                                              flex: 5,
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
                                                            Flexible(
                                                              child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Priority
                                                                        .getBGClr(
                                                                            task['priority']),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                        MaterialPageRoute(
                                                                          builder: (context) => SubTaskPage(
                                                                              isRecordTime: false,
                                                                              taskStatus: task['status'],
                                                                              startDate: task['startDate'],
                                                                              endDate: task['endDate'],
                                                                              taskId: task['id'],
                                                                              taskName: task['name'],
                                                                              taskCode: task['codeTask']),
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
                                                            ),
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
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    task['avatar'] ??
                                                                        "String",
                                                                    width: 25,
                                                                    height: 25,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder: (BuildContext
                                                                            context,
                                                                        Object
                                                                            error,
                                                                        StackTrace?
                                                                            stackTrace) {
                                                                      return Icon(
                                                                        Icons
                                                                            .account_circle_rounded,
                                                                        size:
                                                                            25,
                                                                        color: Colors
                                                                            .white,
                                                                      );
                                                                    },
                                                                  ),
                                                                )),
                                                          ),
                                                      ]),
                                                      const SizedBox(height: 5),
                                                      Stack(children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                '#${task['codeTask']}',
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic, // Chữ in nghiêng
                                                                    color: Priority
                                                                        .getBGClr(
                                                                            task['priority']),
                                                                  ),
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (task['isExpired'])
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 110),
                                                            child: CustomPaint(
                                                              painter:
                                                                  ExplosionPainter(),
                                                              child: Container(
                                                                width: 25,
                                                                height: 20,
                                                                color: Colors
                                                                    .amber,
                                                                child: Center(
                                                                  child: Text(
                                                                    "Trễ",
                                                                    style: TextStyle(
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ]),
                                                      const SizedBox(
                                                          height: 20),
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
                                                                        'Bắt đầu: ',
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
                                                                        '${DateFormat('dd/MM/yyyy   HH:mm').format(DateTime.parse(task['startDate']))}',
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
                                                                        '${DateFormat('dd/MM/yyyy   HH:mm').format(DateTime.parse(task['endDate']))}',
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
                                                          height: 20),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            flex: 2,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Giờ làm dự kiến: ',
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
                                                                        '${task['effortOfTask']}',
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
                                                          Flexible(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Người làm: ',
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
                                                                    text: task[
                                                                        'totaslEmployee'],
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
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            flex: 2,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Giờ làm thực tế (cá nhân): ',
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
                                                                        '${task['actualEffortHour']} giờ ${task['actualEfforMinutes']} phút',
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

  _showBottomSheet(
      BuildContext context, Map<String, dynamic> task, String role) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              15.0), // Điều chỉnh giá trị theo mong muốn của bạn
          topRight: Radius.circular(
              15.0), // Điều chỉnh giá trị theo mong muốn của bạn
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  15.0), // Điều chỉnh giá trị theo mong muốn của bạn
              topRight: Radius.circular(
                  15.0), // Điều chỉnh giá trị theo mong muốn của bạn
            ),
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
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
                        child: buildIconOption(Icons.post_add, "Xem báo cáo"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => SubTaskPage(
                                      isRecordTime: false,
                                      taskStatus: task['status'],
                                      startDate: task['startDate'],
                                      endDate: task['endDate'],
                                      taskId: task['id'],
                                      taskName: task['name'],
                                      taskCode: task['codeTask']),
                                ),
                              )
                              .then((value) => {
                                    if (value != null)
                                      {getTask(true, 10 * page)}
                                  });
                        },
                        child: buildIconOption(Icons.task, "Công việc con"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          task['isHaveSubtask']
                              ? Navigator.of(context)
                                  .push(
                                  MaterialPageRoute(
                                    builder: (context) => SubTaskPage(
                                        isRecordTime: false,
                                        taskStatus: task['status'],
                                        startDate: task['startDate'],
                                        endDate: task['endDate'],
                                        taskId: task['id'],
                                        taskName: task['name'],
                                        taskCode: task['codeTask'],
                                        employeeId: widget.employeeId),
                                  ),
                                )
                                  .then((value) {
                                  if (value != null) {
                                    getTask(true, 10 * page);
                                  }
                                })
                              : Navigator.of(context)
                                  .push(
                                  MaterialPageRoute(
                                    builder: (context) => TimeKeepingInTask(
                                      codeTask:
                                          task['code'] ?? task['codeTask'],
                                      taskId: task['id'],
                                      taskName: task['name'],
                                      isCreate: false,
                                      status: 0,
                                      task: task,
                                    ),
                                  ),
                                )
                                  .then((value) {
                                  if (value != null) {
                                    getTask(true, 10 * page);
                                  }
                                });
                        },
                        child: buildIconOption(Icons.timer, "Xem giờ làm"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
