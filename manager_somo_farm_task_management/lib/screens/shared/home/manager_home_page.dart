import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/choose_habitant.dart';
import 'package:manager_somo_farm_task_management/screens/shared/home/components/task_tile.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/rejection_reason/rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/time_keeping/time_keeping_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/view_rejection_reason/view_rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';

class ManagerHomePage extends StatefulWidget {
  final int farmId;
  const ManagerHomePage({Key? key, required this.farmId}) : super(key: key);

  @override
  ManagerHomePageState createState() => ManagerHomePageState();
}

class ManagerHomePageState extends State<ManagerHomePage> {
  int groupValue = 0;
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;
  bool isMoreLeft = false;
  String? role;
  int? userId;
  bool isLoadingMore = false;
  int page = 1;
  final scrollController = ScrollController();
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await _getTasksForSelectedDateAndStatus(
          page, 10, _selectedDate, groupValue, false);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void removeTask(int taskId) {
    setState(() {
      tasks.removeWhere((task) => task['id'] == taskId);
    });
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu định dạng cho ngôn ngữ Việt Nam
    initializeDateFormatting('vi_VN', null);
    getRoleAndUserId().then((_) {
      _getTasksForSelectedDateAndStatus(1, 10, DateTime.now(), 0, true);
    });

    scrollController.addListener(() {
      _scrollListener();
    });
  }

  Future<void> _getTasksForSelectedDateAndStatus(int index, int pageSize,
      DateTime selectedDate, int status, bool reset) async {
    List<Map<String, dynamic>> selectedDateTasks;
    if (role == "Manager") {
      selectedDateTasks = await TaskService().getTasksByManagerIdDateStatus(
          index, pageSize, userId!, selectedDate, status, "");
    } else {
      selectedDateTasks = await TaskService().getTasksBySupervisorIdDateStatus(
          index, pageSize, userId!, selectedDate, status, "");
    }
    if (reset) {
      setState(() {
        tasks = selectedDateTasks;
        isLoading = false;
      });
    } else {
      setState(() {
        tasks = tasks + selectedDateTasks;
        isLoading = false;
      });
    }
  }

  Future<void> getRoleAndUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    int? userIdStored = prefs.getInt('userId');
    setState(() {
      role = roleStored;
      userId = userIdStored;
    });
  }

  Future<bool> changeTaskStatus(int taskId, int newStatus) async {
    return TaskService().changeTaskStatus(taskId, newStatus);
  }

  Future<bool> cancelRejectTaskStatus(int taskId) async {
    return TaskService().cancelRejectTaskStatus(taskId);
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
                        builder: (context) =>
                            // FirstAddTaskPage(farm: widget.farm),
                            ChooseHabitantPage(farmId: widget.farmId),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kPrimaryColor,
                    ),
                    alignment: Alignment
                        .center, // Đặt alignment thành Alignment.center
                    child: Text(
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
                  isLoading = true;
                });
                _getTasksForSelectedDateAndStatus(
                    1, 10, date, groupValue, true);
              },
              locale: 'vi_VN',
            ),
          ),
          const SizedBox(height: 10),
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
                            if (newValue == 2)
                              setState(() {
                                isMoreLeft = true;
                              });

                            setState(() {
                              groupValue = newValue;
                              isLoading = true;
                            });
                            _getTasksForSelectedDateAndStatus(
                                1, 10, _selectedDate, groupValue, true);
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
                            3: Text(' Không h.thành ',
                                textAlign: TextAlign.center),

                            // Thêm các option khác nếu cần
                          },
                          onValueChanged: (int newValue) {
                            if (newValue == 0)
                              setState(() {
                                isMoreLeft = false;
                              });

                            setState(() {
                              isLoading = true;
                              groupValue = newValue;
                            });
                            _getTasksForSelectedDateAndStatus(
                                1, 10, _selectedDate, groupValue, true);
                          },
                          groupValue: groupValue,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 10),
          _showTask(),
        ],
      ),
    );
  }

  _showTask() {
    return Expanded(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              )
            : tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_backpack,
                          size: 75, // Kích thước biểu tượng có thể điều chỉnh
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
                : RefreshIndicator(
                    notificationPredicate: (_) => true,
                    onRefresh: () => _getTasksForSelectedDateAndStatus(
                        1, 10, _selectedDate, groupValue, true),
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount:
                            isLoadingMore ? tasks.length + 1 : tasks.length,
                        controller: scrollController,
                        itemBuilder: (_, index) {
                          if (index < tasks.length) {
                            Map<String, dynamic> task = tasks[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              child: SlideAnimation(
                                child: FadeInAnimation(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (BuildContext context) {
                                          //     return TaskDetailsPopup(task: task);
                                          //   },
                                          // );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskDetailsPage(
                                                      taskId: task['id']),
                                            ),
                                          );
                                        },
                                        onLongPress: () {
                                          _showBottomSheet(context, task,
                                              _selectedDate, role!);
                                        },
                                        child: Stack(
                                          children: [
                                            TaskTile(task),
                                            if (role == "Manager" &&
                                                    task['managerName'] ==
                                                        null ||
                                                role == "Supervisor" &&
                                                    task['managerName'] != null)
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.topRight,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Tooltip(
                                                  message: role == "Manager"
                                                      ? 'Công việc do người giám sát tạo'
                                                      : 'Công việc do người quản lí tạo',
                                                  child: Icon(
                                                    Icons
                                                        .account_circle_rounded,
                                                    color: Colors.grey[200],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: kPrimaryColor),
                            );
                          }
                        }),
                  ));
  }

  _showBottomSheet(BuildContext context, Map<String, dynamic> task,
      DateTime _selectedDate, String role) {
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
                height: isRejected
                    ? MediaQuery.of(context).size.height * 0.35
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
                    if (isPreparing || isNotCompleted)
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
                                  changeTaskStatus(task['id'], 4).then((value) {
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
                    if (isCompleted)
                      _bottomSheetButton(
                        label: "Đánh giá",
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
                                  changeTaskStatus(task['id'], 4).then((value) {
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
