import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task_add/sub_task_add_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task_update/sub_task_update_page.dart';
import 'package:manager_somo_farm_task_management/services/effort_service.dart';
import 'package:manager_somo_farm_task_management/services/sub_task_service.dart';

class SubTaskPage extends StatefulWidget {
  final int taskId;
  final String taskName;
  final String taskCode;
  final String taskStatus;
  final String startDate, endDate;
  const SubTaskPage(
      {Key? key,
      required this.taskId,
      required this.taskName,
      required this.taskCode,
      required this.startDate,
      required this.endDate,
      required this.taskStatus})
      : super(key: key);

  @override
  SubTaskPageState createState() => SubTaskPageState();
}

class SubTaskPageState extends State<SubTaskPage> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  List<Map<String, dynamic>> filteredTaskList = [];
  bool isLoading = true;
  @override
  initState() {
    super.initState();
    _getSubTask();
    print(widget.taskStatus);
  }

  void removeTask(int subTaskId) {
    setState(() {
      filteredTaskList.removeWhere((task) => task['subtaskId'] == subTaskId);
    });
  }

  Future<void> _getSubTask() async {
    SubTaskService().getSubTaskByTaskId(widget.taskId).then((value) {
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.taskName,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: kSecondColor,
          ),
        ),
      ),
      body: Column(
        children: [
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Danh sách các công việc con:",
                    style: TextStyle(fontSize: 18)),
                (widget.taskStatus == "Chuẩn bị" ||
                        widget.taskStatus == "Từ chối" ||
                        widget.taskStatus == "Đang thực hiện")
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => CreateSubTask(
                                taskCode: widget.taskCode,
                                taskId: widget.taskId,
                                taskName: widget.taskName,
                                startDate: widget.startDate,
                                endDate: widget.endDate,
                              ),
                            ),
                          )
                              .then((value) {
                            if (value != null) {
                              _getSubTask();
                            }
                          });
                          ;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          minimumSize: Size(80, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Thêm",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : Container(),
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

                              return GestureDetector(
                                onLongPress: () {
                                  if (widget.taskStatus == "Chuẩn bị" ||
                                      widget.taskStatus == "Từ chối" ||
                                      widget.taskStatus == "Đang thực hiện")
                                    _showBottomSheet(context, task);
                                  else
                                    SnackbarShowNoti.showSnackbar(
                                        "Không có tùy chọn cho công việc đã hoàn thành",
                                        true);
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
                                            color: Colors
                                                .grey, // Màu của đường viền
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
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Tooltip(
                                                        message: "Chấm công",
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await showDialog<
                                                                void>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Chấm công'),
                                                                  content:
                                                                      Container(
                                                                    height: 100,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                            'Nhập giờ thực hiện thực tế'),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: TextField(
                                                                                decoration: InputDecoration(labelText: 'Giờ'),
                                                                                keyboardType: TextInputType.number,
                                                                                controller: hourController,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 16), // Khoảng trống giữa hai ô input
                                                                            Expanded(
                                                                              child: TextField(
                                                                                decoration: InputDecoration(labelText: 'Phút'),
                                                                                keyboardType: TextInputType.number,
                                                                                controller: minuteController,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        String
                                                                            hourText =
                                                                            hourController.text;
                                                                        String
                                                                            minuteText =
                                                                            minuteController.text;
                                                                        int hours =
                                                                            int.tryParse(hourText) ??
                                                                                0;
                                                                        int minutes =
                                                                            int.tryParse(minuteText) ??
                                                                                0;

                                                                        Map<String,
                                                                                dynamic>
                                                                            data =
                                                                            {
                                                                          'employeeId':
                                                                              task['employeeId'],
                                                                          'actualEfforMinutes':
                                                                              minutes,
                                                                          'actualEffortHour':
                                                                              hours
                                                                        };
                                                                        if (hourController.text.isEmpty &&
                                                                            minuteController.text.isEmpty)
                                                                          return null;
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        EffortService()
                                                                            .createEffortBySubtask(task['subtaskId'],
                                                                                data)
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            minuteController.text =
                                                                                "";
                                                                            hourController.text =
                                                                                "";
                                                                          });
                                                                          if (value)
                                                                            _getSubTask();
                                                                          SnackbarShowNoti.showSnackbar(
                                                                              "Chấm công thành công",
                                                                              false);
                                                                        }).catchError((e) {
                                                                          SnackbarShowNoti.showSnackbar(
                                                                              e.toString(),
                                                                              true);
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                          'Lưu'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        minuteController.text =
                                                                            "";
                                                                        hourController.text =
                                                                            "";
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Đóng',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .grading_rounded,
                                                              color:
                                                                  kPrimaryColor),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
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
                                                                    'Bắt đầu: ',
                                                                style:
                                                                    TextStyle(
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
                                                                    '${DateFormat('dd/MM/yyyy   HH:mm aa').format(DateTime.parse(task['startDay']))}',
                                                                style:
                                                                    TextStyle(
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
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
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
                                                                    'Kết thúc: ',
                                                                style:
                                                                    TextStyle(
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
                                                                    '${DateFormat('dd/MM/yyyy   HH:mm aa').format(DateTime.parse(task['endDay']))}',
                                                                style:
                                                                    TextStyle(
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
                                                                style:
                                                                    TextStyle(
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
                                                                style:
                                                                    TextStyle(
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
                                                                style:
                                                                    TextStyle(
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
                                                                    '${task['actualEffortHour']} giờ ${task['actualEfforMinutes']} phút',
                                                                style:
                                                                    TextStyle(
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
                                                  const SizedBox(height: 10),
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
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
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
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                        task['description'] ==
                                                                ""
                                                            ? "Không có mô tả"
                                                            : task[
                                                                'description'],
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
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

  _showBottomSheet(BuildContext context, Map<String, dynamic> subTask) {
    showModalBottomSheet(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.3,
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
              _bottomSheetButton(
                label: "Chỉnh sửa",
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => UpdateSubTask(
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                        taskCode: widget.taskCode,
                        taskId: widget.taskId,
                        taskName: widget.taskName,
                        subtask: subTask,
                      ),
                    ),
                  )
                      .then((value) {
                    if (value != null) {
                      _getSubTask();
                    }
                  });
                },
                cls: kPrimaryColor,
                context: context,
              ),
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
                          Navigator.of(context).pop();

                          SubTaskService()
                              .deleteSubTask(subTask['subtaskId'])
                              .then((value) {
                            if (value) {
                              removeTask(subTask['subtaskId']);

                              SnackbarShowNoti.showSnackbar(
                                  "Xóa thành công!", false);
                            }
                          }).catchError((e) {
                            Navigator.of(context).pop();
                            SnackbarShowNoti.showSnackbar(e.toString(), true);
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
              SizedBox(height: 30),
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
