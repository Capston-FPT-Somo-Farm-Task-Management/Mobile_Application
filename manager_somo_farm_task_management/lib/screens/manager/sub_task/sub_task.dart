import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/sub_task_add/sub_task_add.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_details/task_details_popup.dart';
import 'package:manager_somo_farm_task_management/services/sub_task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class SubTaskPage extends StatefulWidget {
  final int taskId;
  final String taskName;
  const SubTaskPage({Key? key, required this.taskId, required this.taskName})
      : super(key: key);

  @override
  SubTaskPageState createState() => SubTaskPageState();
}

class SubTaskPageState extends State<SubTaskPage> {
  String? selectedFilter;
  String selectedDate = "";
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> subTasks = [];
  List<Map<String, dynamic>> filteredTaskList = [];
  bool isLoading = true;
  int groupValue = 0;
  bool isMoreLeft = false;
  @override
  initState() {
    super.initState();
    _getSubTask();
  }

  void searchTasks(String keyword) {
    setState(() {
      filteredTaskList = subTasks
          .where((task) => removeDiacritics(task['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> _getSubTask() async {
    SubTaskService().getSubTaskByTaskId(widget.taskId).then((value) {
      setState(() {
        isLoading = false;
        subTasks = value;
        filteredTaskList = value;
      });
    }).catchError((e) {
      SnackbarShowNoti.showSnackbar(e, true);
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
          const SizedBox(height: 30),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Danh sách các công việc con:",
                    style: TextStyle(fontSize: 18)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => CreateSubTask(
                            taskId: widget.taskId, taskName: widget.taskName),
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
                ),
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
                                                      Text(
                                                        task['taskName']
                                                                    .length >
                                                                25
                                                            ? '${task['taskName'].substring(0, 22)}...'
                                                            : task['taskName'],
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                            .access_time_rounded,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "${task['description']}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Giám sát: ${task['name']}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 15,
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
                                          color: Colors
                                              .grey[400], // Đặt màu xám ở đây
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Loại: ${task['taskTypeName']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Ưu tiên: ${task['priority']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                      ),
          ),
        ],
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskEvidence(),
                      ),
                    );
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
                              // changeTaskStatus(task['id'], 4).then((value) {
                              //   if (value) {
                              //     _getTasksForSelectedDateAndStatus(
                              //         _selectedDate, groupValue);
                              //     Navigator.of(context).pop();
                              //     SnackbarShowNoti.showSnackbar(
                              //         "Xóa thành công!", false);
                              //   } else {
                              //     SnackbarShowNoti.showSnackbar(
                              //         "Xảy ra lỗi!", true);
                              //   }
                              // });
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
