import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task_add/sub_task_add_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task_update/sub_task_update_page.dart';
import 'package:manager_somo_farm_task_management/services/sub_task_service.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubTaskPage extends StatefulWidget {
  final int taskId;
  final String taskName;
  final String taskCode;
  final String taskStatus;
  final String startDate, endDate;
  final bool isRecordTime;
  final int? employeeId;
  const SubTaskPage(
      {Key? key,
      required this.taskId,
      required this.taskName,
      required this.taskCode,
      required this.startDate,
      required this.endDate,
      required this.taskStatus,
      required this.isRecordTime,
      this.employeeId})
      : super(key: key);

  @override
  SubTaskPageState createState() => SubTaskPageState();
}

class SubTaskPageState extends State<SubTaskPage> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  List<Map<String, dynamic>> filteredTaskList = [];
  bool isLoading = true;
  String? role;
  @override
  initState() {
    super.initState();
    getRole();
    _getSubTask();
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  void removeTask(int subTaskId) {
    setState(() {
      filteredTaskList.removeWhere((task) => task['subtaskId'] == subTaskId);
    });
  }

  Future<void> _getSubTask() async {
    SubTaskService()
        .getSubTaskByTaskId(widget.taskId, widget.employeeId)
        .then((value) {
      setState(() {
        isLoading = false;
        filteredTaskList = value;
      });
    }).catchError((e) {
      // SnackbarShowNoti.showSnackbar(e.toString(), true);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isLoading && role != "Manager"
          ? FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => CreateSubTask(
                      taskCode: widget.taskCode,
                      taskId: widget.taskId,
                      taskName: widget.taskName,
                      startDate: widget.startDate,
                    ),
                  ),
                )
                    .then((value) {
                  if (value != null) {
                    _getSubTask();
                  }
                });
              })
          : null,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isRecordTime
              ? role == "Manager"
                  ? "Giờ làm"
                  : "Xác nhận giờ làm"
              : widget.taskName,
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop("ok");
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: kSecondColor,
          ),
        ),
        actions: role == "Manager"
            ? null
            : [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context1) {
                          return ConfirmDeleteDialog(
                            title: "Xác nhận giờ làm",
                            content:
                                'Công việc sẽ chuyển sang trạng thái ""Hoàn thành"',
                            onConfirm: () {
                              TaskService()
                                  .changeStatusToDone(widget.taskId)
                                  .then((value) {
                                if (value) {
                                  Navigator.of(context).pop("ok");
                                  SnackbarShowNoti.showSnackbar(
                                      "Đổi thành công!", false);
                                } else {
                                  SnackbarShowNoti.showSnackbar(
                                      "Xảy ra lỗi!", true);
                                }
                              }).catchError((e) {
                                SnackbarShowNoti.showSnackbar(
                                    e.toString(), true);
                              });
                            },
                            buttonConfirmText: "Đồng ý",
                          );
                        });
                  },
                  child: widget.isRecordTime && widget.taskStatus != "Đã đóng"
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Center(child: Text("Lưu")),
                        )
                      : Container(),
                ),
              ],
      ),
      body: Column(
        children: [
          if (widget.isRecordTime) const SizedBox(height: 20),
          widget.isRecordTime
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.taskName,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                )
              : Container(),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "#${widget.taskCode}",
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: kSecondColor),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Danh sách các công việc con:",
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Divider(
              color: Colors.grey, // Đặt màu xám
              height: 1, // Độ dày của dòng gạch
              thickness: 1, // Độ dày của dòng gạch (có thể thay đổi)
            ),
          ),
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
                              "Chưa có công việc con nào",
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
                          onRefresh: () => _getSubTask(),
                          child: ListView.separated(
                            itemCount: filteredTaskList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 25);
                            },
                            itemBuilder: (context, index) {
                              final task = filteredTaskList[index];

                              return Container(
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color:
                                              Colors.grey, // Màu của đường viền
                                          width: 1.0, // Độ dày của đường viền
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          task['name'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      if (role != "Manager")
                                                        PopupMenuButton<String>(
                                                          icon: Icon(
                                                              Icons.more_vert),
                                                          onSelected: (value) {
                                                            if (value ==
                                                                'Delete') {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context1) {
                                                                  return ConfirmDeleteDialog(
                                                                    title:
                                                                        "Xóa công việc",
                                                                    content:
                                                                        "Bạn có chắc muốn xóa công việc này?",
                                                                    onConfirm:
                                                                        () {
                                                                      SubTaskService()
                                                                          .deleteSubTask(task[
                                                                              'subtaskId'])
                                                                          .then(
                                                                              (value) {
                                                                        if (value) {
                                                                          removeTask(
                                                                              task['subtaskId']);

                                                                          SnackbarShowNoti.showSnackbar(
                                                                              "Xóa thành công!",
                                                                              false);
                                                                        }
                                                                      }).catchError(
                                                                              (e) {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        SnackbarShowNoti.showSnackbar(
                                                                            e.toString(),
                                                                            true);
                                                                      });
                                                                    },
                                                                    buttonConfirmText:
                                                                        "Xóa",
                                                                  );
                                                                },
                                                              );
                                                            }
                                                            if (value ==
                                                                'Edit') {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UpdateSubTask(
                                                                    startDate:
                                                                        widget
                                                                            .startDate,
                                                                    taskCode: widget
                                                                        .taskCode,
                                                                    taskId: widget
                                                                        .taskId,
                                                                    taskName: widget
                                                                        .taskName,
                                                                    subtask:
                                                                        task,
                                                                  ),
                                                                ),
                                                              )
                                                                  .then(
                                                                      (value) {
                                                                if (value !=
                                                                    null) {
                                                                  _getSubTask();
                                                                }
                                                              });
                                                            }
                                                          },
                                                          itemBuilder:
                                                              (BuildContext
                                                                  context) {
                                                            return <PopupMenuEntry<
                                                                String>>[
                                                              PopupMenuItem<
                                                                  String>(
                                                                value: 'Delete',
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .red),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      'Xóa',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              PopupMenuItem<
                                                                  String>(
                                                                value: 'Edit',
                                                                child: Row(
                                                                  children: [
                                                                    Icon(Icons
                                                                        .edit_note_rounded),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      'Chỉnh sửa',
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ];
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "#${task['code']}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        17.0, // Kích thước nhỏ hơn
                                                    fontStyle: FontStyle.italic,
                                                    color: kSecondColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.access_time_rounded,
                                                      color: Colors.black87,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Ngày thực hiện: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '${DateFormat('dd/MM/yyyy ').format(DateTime.parse(task['daySubmit']))}',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.person_2_sharp,
                                                      color: Colors.black87,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Nhân viên: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '${task['codeEmployee']} - ${task['employeeName']}',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.timelapse_rounded,
                                                      color: Colors.black87,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Giờ làm thực tế: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: task['actualEffortHour'] ==
                                                                          0 &&
                                                                      task['actualEfforMinutes'] ==
                                                                          0
                                                                  ? "Chưa ghi nhận"
                                                                  : '${task['actualEffortHour']} giờ ${task['actualEfforMinutes']} phút',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .info_outline_rounded,
                                                      color: Colors.black,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "Mô tả:",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  height: 90,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black45,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                      task['description'] == ""
                                                          ? "Không có mô tả"
                                                          : task['description'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            task['description'] ==
                                                                    ""
                                                                ? Colors.grey
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
