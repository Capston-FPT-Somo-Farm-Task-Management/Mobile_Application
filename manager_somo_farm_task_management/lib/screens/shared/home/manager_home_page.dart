import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/componets/option.dart';
import 'package:manager_somo_farm_task_management/screens/shared/home/components/task_tile.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/rejection_reason/rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/time_keeping/time_keeping_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/view_rejection_reason/view_rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int totalPages = 5;
  GlobalKey _keyPrepare = GlobalKey();
  GlobalKey _keyDoing = GlobalKey();
  GlobalKey _keyComplete = GlobalKey();
  GlobalKey _keyNotCom = GlobalKey();
  GlobalKey _keyReject = GlobalKey();
  double _offsetX = 0.0;
  final scrollControllerOption = ScrollController();
  final TextEditingController searchController = TextEditingController();
  String searchValue = "";
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
          index, pageSize, userId!, selectedDate, status, searchValue, 1);
    } else {
      selectedDateTasks = await TaskService().getTasksBySupervisorIdDateStatus(
          index, pageSize, userId!, selectedDate, status, searchValue, 1);
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

  Future<bool> deleteTask(int taskId) async {
    return TaskService().deleteTask(taskId);
  }

  @override
  Widget build(BuildContext context) {
    // Tiếp tục với mã widget của bạn như trước
    var vietnameseDate = DateFormat.yMMMMd('vi_VN').format(DateTime.now());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Lịch trình',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            iconSize: 35,
            onPressed: () {
              HamburgerMenu.showReusableBottomSheet(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              height: 42,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (keyword) {
                    setState(() {
                      searchValue = keyword.trim();
                      page = 1;
                    });

                    _getTasksForSelectedDateAndStatus(
                        1, 10, _selectedDate, groupValue, true);
                  },
                  decoration: const InputDecoration(
                    hintText: "Tìm kiếm...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vietnameseDate,
                        style: subHeadingStyle.copyWith(fontSize: 22),
                      ),
                      Text(
                        "Hôm nay",
                        style: headingStyle.copyWith(
                            color: kSecondColor, fontSize: 27),
                      ),
                    ],
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             // FirstAddTaskPage(farm: widget.farm),
                  //             ChooseHabitantPage(farmId: widget.farmId),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     width: 100,
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: kPrimaryColor,
                  //     ),
                  //     alignment: Alignment
                  //         .center, // Đặt alignment thành Alignment.center
                  //     child: Text(
                  //       "+ Thêm việc",
                  //       style: TextStyle(
                  //         color: kTextWhiteColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20),
              child: DatePicker(
                DateTime.now(),
                height: 90,
                width: 70,
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
            SingleChildScrollView(
              controller: scrollControllerOption,
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SelectableTextWidget(
                      keyGlobal: _keyPrepare,
                      text: "Chuẩn bị",
                      isSelected: groupValue == 0,
                      onTap: () {
                        scrollTo(key: _keyPrepare);
                        setState(() {
                          groupValue = 0;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(
                            1, 10, _selectedDate, groupValue, true);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyDoing,
                      text: "Đang thực hiện",
                      isSelected: groupValue == 1,
                      onTap: () {
                        scrollTo(key: _keyDoing);
                        setState(() {
                          groupValue = 1;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(
                            1, 10, _selectedDate, groupValue, true);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyComplete,
                      text: "Hoàn thành",
                      isSelected: groupValue == 2,
                      onTap: () {
                        scrollTo(key: _keyComplete);
                        setState(() {
                          groupValue = 2;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(
                            1, 10, _selectedDate, groupValue, true);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyNotCom,
                      text: "Không hoàn thành",
                      isSelected: groupValue == 3,
                      onTap: () {
                        scrollTo(key: _keyNotCom);
                        setState(() {
                          groupValue = 3;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(
                            1, 10, _selectedDate, groupValue, true);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyReject,
                      text: "Từ chối",
                      isSelected: groupValue == 5,
                      onTap: () {
                        scrollTo(key: _keyReject);
                        setState(() {
                          groupValue = 5;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(
                            1, 10, _selectedDate, groupValue, true);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _offsetX += details.primaryDelta!;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    double screenWidth = MediaQuery.of(context).size.width;
                    if (_offsetX.abs() < screenWidth * 0.5) {
                      setState(() {
                        _offsetX = 0.0;
                      });
                    } else {
                      if (_offsetX > 0) {
                        // Vuốt sang phải
                        setState(() {
                          if (groupValue != 0) {
                            _offsetX = screenWidth;
                            isLoading = true;
                            if (groupValue == 1) {
                              groupValue = 0;
                              scrollTo(key: _keyPrepare);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            } else if (groupValue == 2) {
                              groupValue = 1;
                              scrollTo(key: _keyDoing);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            } else if (groupValue == 3) {
                              groupValue = 2;
                              scrollTo(key: _keyComplete);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            } else if (groupValue == 5) {
                              groupValue = 3;
                              scrollTo(key: _keyNotCom);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            }
                            ;
                          }
                        });
                      } else if (_offsetX < 0) {
                        // Vuốt sang trái
                        setState(() {
                          if (groupValue != 5) {
                            _offsetX = -screenWidth;
                            isLoading = true;
                            if (groupValue == 0) {
                              groupValue = 1;
                              scrollTo(key: _keyDoing);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            } else if (groupValue == 1) {
                              groupValue = 2;
                              scrollTo(key: _keyComplete);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            } else if (groupValue == 2) {
                              groupValue = 3;
                              scrollTo(key: _keyNotCom);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            } else if (groupValue == 3) {
                              groupValue = 5;
                              scrollTo(key: _keyReject);
                              _getTasksForSelectedDateAndStatus(
                                  1, 10, _selectedDate, groupValue, true);
                            }
                          }
                        });
                      }
                      setState(() {
                        _offsetX = 0;
                      });
                    }
                  },
                  child: Transform.translate(
                    offset: Offset(_offsetX, 0.0),
                    child: _showTask(),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void scrollTo({required GlobalKey key}) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    scrollControllerOption.animateTo(position.dx,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  _showTask() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        color: Colors.grey[200],
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
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskDetailsPage(
                                                      taskId: task['id']),
                                            ),
                                          )
                                              .then((value) {
                                            if (value != null) {
                                              setState(() {
                                                page = 1;
                                              });
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10,
                                                  _selectedDate,
                                                  groupValue,
                                                  true);
                                            }
                                          });
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
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        (role == "Manager" &&
                                                                task['managerName'] ==
                                                                    null)
                                                            ? task[
                                                                'avatarSupervisor']
                                                            : (role == "Supervisor" &&
                                                                    task['managerName'] !=
                                                                        null)
                                                                ? task[
                                                                    'avatarManager']
                                                                : "string",
                                                        width: 25,
                                                        height: 25,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Icon(
                                                            Icons
                                                                .account_circle_rounded,
                                                            size: 25,
                                                            color: Colors.black,
                                                          );
                                                        },
                                                      ),
                                                    )),
                                              ),
                                            if (task['isHaveEvidence'])
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.bottomLeft,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Tooltip(
                                                  message: "Có báo cáo",
                                                  child: Icon(
                                                    Icons.barcode_reader,
                                                    color: Colors.black54,
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
                                codeTask: task['code'],
                                taskId: task['id'],
                                taskName: task['name'],
                                isCreate: false,
                                status: 0,
                                task: task,
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
                                    codeTask: task['code'],
                                    taskId: task['id'],
                                    taskName: task['name'],
                                    isCreate: true,
                                    status: 2,
                                    task: task,
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
                                    codeTask: task['code'],
                                    taskId: task['id'],
                                    taskName: task['name'],
                                    isCreate: true,
                                    status: 3,
                                    task: task,
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
                                codeTask: task['code'],
                                taskId: task['id'],
                                taskName: task['name'],
                                isCreate: false,
                                status: 0,
                                task: task,
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
