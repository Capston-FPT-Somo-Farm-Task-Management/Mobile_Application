import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/explosion.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/option.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/evidence_add_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task/sub_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/components/divider_option.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/components/icon_option.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/components/option_task.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_assign/task_assign_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_draft_todo_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/rejection_reason/rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/time_keeping/time_keeping_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/view_rejection_reason/view_rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  bool showRepeatedTasks = false;
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
  GlobalKey _keyDraft = GlobalKey();
  GlobalKey _keyTodo = GlobalKey();
  GlobalKey _keyAssigned = GlobalKey();
  GlobalKey _keyDoing = GlobalKey();
  GlobalKey _keyComplete = GlobalKey();
  GlobalKey _keyPending = GlobalKey();
  GlobalKey _keyReject = GlobalKey();
  GlobalKey _keyCancel = GlobalKey();
  GlobalKey _keyClosed = GlobalKey();
  double _offsetX = 0.0;
  final scrollControllerOption = ScrollController();
  bool isImportant = false;
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
    return TaskService().cancelRejectTaskStatus(taskId, isImportant);
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
    getFarmId().then((value) {
      farmId = value;
    });
    getRole().then((_) {
      if (role == "Supervisor") groupValue = 1;
      _getTasksForSelectedDateAndStatus(page, 10, null, groupValue, true, "");
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
          index,
          pageSize,
          userId!,
          selectedDate,
          status,
          search,
          showRepeatedTasks ? 0 : 1);
    } else {
      selectedDateTasks = await TaskService().getTasksBySupervisorIdDateStatus(
          index,
          pageSize,
          userId!,
          selectedDate,
          status,
          search,
          showRepeatedTasks ? 0 : 1);
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Công việc',
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
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (role == "Manager")
                            Checkbox(
                              value: showRepeatedTasks,
                              onChanged: (value) {
                                setState(() {
                                  showRepeatedTasks = value!;
                                  page = 1;
                                });
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              },
                            ),
                          if (role == "Manager")
                            Text('Chỉ công việc có lặp lại'),
                        ],
                      ),
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
                                  _getTasksForSelectedDateAndStatus(1, 10, null,
                                      groupValue, true, searchValue);
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
                      ),
                    ],
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              controller: scrollControllerOption,
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (role == "Manager")
                      SelectableTextWidget(
                        keyGlobal: _keyDraft,
                        text: "Bản nháp",
                        isSelected: groupValue == 0,
                        onTap: () {
                          scrollTo(key: _keyDraft);
                          setState(() {
                            groupValue = 0;
                            isLoading = true;
                            page = 1;
                          });
                          _getTasksForSelectedDateAndStatus(1, 10,
                              _selectedDate, groupValue, true, searchValue);
                        },
                      ),
                    SelectableTextWidget(
                      keyGlobal: _keyTodo,
                      text: "Chuẩn bị",
                      isSelected: groupValue == 1,
                      onTap: () {
                        scrollTo(key: _keyTodo);
                        setState(() {
                          groupValue = 1;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyAssigned,
                      text: "Đã giao",
                      isSelected: groupValue == 2,
                      onTap: () {
                        scrollTo(key: _keyAssigned);
                        setState(() {
                          groupValue = 2;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyDoing,
                      text: "Đang thực hiện",
                      isSelected: groupValue == 3,
                      onTap: () {
                        scrollTo(key: _keyDoing);
                        setState(() {
                          groupValue = 3;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyComplete,
                      text: "Hoàn thành",
                      isSelected: groupValue == 4,
                      onTap: () {
                        scrollTo(key: _keyComplete);
                        setState(() {
                          groupValue = 4;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyPending,
                      text: "Tạm hoãn",
                      isSelected: groupValue == 5,
                      onTap: () {
                        scrollTo(key: _keyPending);
                        setState(() {
                          groupValue = 5;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyReject,
                      text: "Từ chối",
                      isSelected: groupValue == 6,
                      onTap: () {
                        scrollTo(key: _keyReject);
                        setState(() {
                          groupValue = 6;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyCancel,
                      text: "Hủy bỏ",
                      isSelected: groupValue == 7,
                      onTap: () {
                        scrollTo(key: _keyCancel);
                        setState(() {
                          groupValue = 7;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                    SelectableTextWidget(
                      keyGlobal: _keyClosed,
                      text: "Đã đóng",
                      isSelected: groupValue == 8,
                      onTap: () {
                        scrollTo(key: _keyClosed);
                        setState(() {
                          groupValue = 8;
                          isLoading = true;
                          page = 1;
                        });
                        _getTasksForSelectedDateAndStatus(1, 10, _selectedDate,
                            groupValue, true, searchValue);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _offsetX += details.primaryDelta!;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    double screenWidth = MediaQuery.of(context).size.width;
                    Map<int, GlobalKey> keyMap = {
                      0: _keyDraft,
                      1: _keyTodo,
                      2: _keyAssigned,
                      3: _keyDoing,
                      4: _keyComplete,
                      5: _keyPending,
                      6: _keyReject,
                      7: _keyCancel,
                      8: _keyClosed,
                    };
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

                            if (groupValue > 0 && groupValue <= 8) {
                              groupValue -= 1;
                              scrollTo(key: keyMap[groupValue]!);
                              _getTasksForSelectedDateAndStatus(1, 10,
                                  _selectedDate, groupValue, true, searchValue);
                            }
                          }
                        });
                      } else if (_offsetX < 0) {
                        // Vuốt sang trái
                        setState(() {
                          if (groupValue != 8) {
                            _offsetX = -screenWidth;
                            isLoading = true;

                            if (groupValue >= 0 && groupValue < 8) {
                              groupValue += 1;
                              scrollTo(key: keyMap[groupValue]!);
                              _getTasksForSelectedDateAndStatus(1, 10,
                                  _selectedDate, groupValue, true, searchValue);
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

    scrollControllerOption.position.ensureVisible(
      renderBox,
      alignment: 0.5,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  _showTask() {
    return Container(
      color: Colors.transparent,
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
                        size: 75, // Kích thước biểu tượng có thể điều chỉnh
                        color: Colors.grey, // Màu của biểu tượng
                      ),
                      SizedBox(
                          height: 16), // Khoảng cách giữa biểu tượng và văn bản
                      Text(
                        "Không có công việc nào",
                        style: TextStyle(
                          fontSize: 20, // Kích thước văn bản có thể điều chỉnh
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
                    onRefresh: () => _getTasksForSelectedDateAndStatus(
                        1, 10, _selectedDate, groupValue, true, searchValue),
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: isLoadingMore
                          ? filteredTaskList.length + 1
                          : filteredTaskList.length,
                      separatorBuilder: (BuildContext context, int index) {
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
                                  builder: (context) =>
                                      TaskDetailsPage(taskId: task['id']),
                                ),
                              )
                                  .then((value) {
                                if (value != null)
                                  _getTasksForSelectedDateAndStatus(
                                      1,
                                      10 * page,
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
                                    offset: Offset(1, 4), // Shadow position
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
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
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
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    if (task['status'] != "Bản nháp" &&
                                                        task['status'] !=
                                                            "Chuẩn bị" &&
                                                        task['status'] !=
                                                            "Từ chối" &&
                                                        task['status'] !=
                                                            "Đã giao")
                                                      Flexible(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder: (context) => SubTaskPage(
                                                                    isRecordTime:
                                                                        false,
                                                                    taskStatus:
                                                                        task[
                                                                            'status'],
                                                                    startDate: task[
                                                                        'startDate'],
                                                                    endDate: task[
                                                                        'endDate'],
                                                                    taskId: task[
                                                                        'id'],
                                                                    taskName: task[
                                                                        'name'],
                                                                    taskCode: task[
                                                                        'code']),
                                                              ),
                                                            )
                                                                .then((value) {
                                                              if (value !=
                                                                  null) {
                                                                _getTasksForSelectedDateAndStatus(
                                                                    1,
                                                                    10 * page,
                                                                    _selectedDate,
                                                                    groupValue,
                                                                    true,
                                                                    searchValue);
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Priority
                                                                    .getBGClr(task[
                                                                        'priority']),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color: Colors
                                                                    .grey[200],
                                                                size: 15,
                                                              )),
                                                        ),
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
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    alignment:
                                                        Alignment.topRight,
                                                    padding: task['status'] !=
                                                                "Bản nháp" &&
                                                            task['status'] !=
                                                                "Đã giao" &&
                                                            task['status'] !=
                                                                "Từ chối" &&
                                                            (role == "Supervisor" &&
                                                                    (task['status'] !=
                                                                        "Chuẩn bị") ||
                                                                role ==
                                                                    "Manager")
                                                        ? const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 35)
                                                        : null,
                                                    child: Tooltip(
                                                        message: role ==
                                                                "Manager"
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
                                                                    Object
                                                                        error,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              return Icon(
                                                                Icons
                                                                    .account_circle_rounded,
                                                                size: 25,
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
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        '#${task['code']}',
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                            fontSize: 15,
                                                            fontStyle: FontStyle
                                                                .italic, // Chữ in nghiêng
                                                            color: Priority
                                                                .getBGClr(task[
                                                                    'priority']),
                                                          ),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (task['isExpired'] &&
                                                    task['status'] !=
                                                        "Bản nháp")
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 110),
                                                    child: CustomPaint(
                                                      painter:
                                                          ExplosionPainter(),
                                                      child: Container(
                                                        width: 25,
                                                        height: 20,
                                                        color: Colors.amber,
                                                        child: Center(
                                                          child: Text(
                                                            "Trễ",
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ]),
                                              const SizedBox(height: 20),
                                              Stack(children: [
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
                                                              text: 'Bắt đầu: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: task['startDate'] ==
                                                                      null
                                                                  ? "Chưa có"
                                                                  : '${DateFormat('dd/MM/yyyy   HH:mm aa').format(DateTime.parse(task['startDate']))}',
                                                              style: TextStyle(
                                                                fontSize: 14,
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
                                                if (task['isHaveEvidence'])
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    alignment:
                                                        Alignment.topRight,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0),
                                                    child: Tooltip(
                                                      message: "Có báo cáo",
                                                      child: Icon(
                                                        Icons.barcode_reader,
                                                        color: Colors.black54,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                              ]),
                                              const SizedBox(height: 5),
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
                                                            text: 'Kết thúc: ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: task['endDate'] ==
                                                                    null
                                                                ? "Chưa có"
                                                                : '${DateFormat('dd/MM/yyyy   HH:mm aa').format(DateTime.parse(task['endDate']))}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 30),
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
                                                            text: 'Giám sát: ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: task[
                                                                    'supervisorName'] ??
                                                                "Chưa có",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Vị trí: ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: task['isPlant'] !=
                                                                    null
                                                                ? task['fieldName'] ??
                                                                    "Chưa có"
                                                                : (task['addressDetail']
                                                                            .toString()
                                                                            .isEmpty ||
                                                                        task['addressDetail'] ==
                                                                            null
                                                                    ? "Chưa có"
                                                                    : task[
                                                                        'addressDetail']),
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Loại: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey[200],
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: task['taskTypeName'] ??
                                                      "Chưa có",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[200],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Ưu tiên: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.grey[200],
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${task['priority']}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[200],
                                                ),
                                              ),
                                            ],
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                            child:
                                CircularProgressIndicator(color: kPrimaryColor),
                          );
                        }
                      },
                    ),
                  ),
                ),
    );
  }

  _showBottomSheet(BuildContext context, Map<String, dynamic> task,
      DateTime? _selectedDate, String role) {
    bool isDraft = task['status'] == "Bản nháp";
    bool isPreparing = task['status'] == "Chuẩn bị";
    bool isAsigned = task['status'] == "Đã giao";
    bool isDoing = task['status'] == "Đang thực hiện";
    bool isCompleted = task['status'] == "Hoàn thành";
    bool isPending = task['status'] == "Tạm hoãn";
    bool isRejected = task['status'] == "Từ chối";
    bool isCanceled = task['status'] == "Hủy bỏ";
    bool isClosed = task['status'] == "Đã đóng";
    role == "Manager"
        ? showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    15.0), // Điều chỉnh giá trị theo mong muốn của bạn
                topRight: Radius.circular(
                    15.0), // Điều chỉnh giá trị theo mong muốn của bạn
              ),
            ),
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
                            if (isDraft || isPreparing)
                              if (role == "Manager" &&
                                      task['managerName'] != null ||
                                  role != "Manager" &&
                                      task['managerName'] == null)
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateTaskDraftTodoPage(
                                                  reDo: false,
                                                  changeTodo: false,
                                                  task: task,
                                                  role: role),
                                        ),
                                      )
                                          .then((value) {
                                        if (value != null) {
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      });
                                    },
                                    child: buildIconOption(
                                        Icons.edit_square, "Chỉnh sửa")),
                            if (isDraft || isPreparing)
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context1) {
                                        return ConfirmDeleteDialog(
                                          title: "Tạo bản sao công việc",
                                          content:
                                              'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                          onConfirm: () {
                                            Navigator.of(context).pop();
                                            TaskService()
                                                .cloneTask(task['id'])
                                                .then((value) {
                                              if (value) {
                                                _getTasksForSelectedDateAndStatus(
                                                    1,
                                                    10 * page,
                                                    _selectedDate,
                                                    groupValue,
                                                    true,
                                                    searchValue);
                                                SnackbarShowNoti.showSnackbar(
                                                    "Tạo bản sao thành công!",
                                                    false);
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
                                      },
                                    );
                                  },
                                  child: buildIconOption(
                                      Icons.copy, "Tạo bản sao")),
                          ],
                        ),
                      ),
                      buildDivider(),
                      if (isDraft)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => UpdateTaskDraftTodoPage(
                                    reDo: false,
                                    changeTodo: true,
                                    task: task,
                                    role: role),
                              ),
                            )
                                .then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.change_circle,
                              'Chuyển sang "Chuẩn bị"', null),
                        ),
                      if (isPreparing)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            TaskService()
                                .updateStatusFromTodoToDraft(task['id'])
                                .then((value) {
                              if (value) {
                                SnackbarShowNoti.showSnackbar(
                                    "Đã đổi thành công!", false);
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            }).catchError((e) {
                              SnackbarShowNoti.showSnackbar(e.toString(), true);
                            });
                          },
                          child: buildOptionTask(Icons.change_circle,
                              'Chuyển thành "Bản nháp"', null),
                        ),
                      buildDivider(),
                      if (isDraft || isPreparing)
                        GestureDetector(
                          child: buildOptionTask(
                              Icons.delete, "Xóa công việc", Colors.red),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context1) {
                                return ConfirmDeleteDialog(
                                  title: "Xóa công việc",
                                  content:
                                      "Bạn có chắc muốn xóa công việc này?",
                                  onConfirm: () {
                                    Navigator.of(context).pop();
                                    deleteTask(task['id']).then((value) {
                                      if (value) {
                                        _getTasksForSelectedDateAndStatus(
                                            1,
                                            10 * page,
                                            _selectedDate,
                                            groupValue,
                                            true,
                                            searchValue);
                                        SnackbarShowNoti.showSnackbar(
                                            "Xóa thành công!", false);
                                      } else {
                                        SnackbarShowNoti.showSnackbar(
                                            "Xảy ra lỗi!", true);
                                      }
                                    }).catchError((e) {
                                      SnackbarShowNoti.showSnackbar(
                                          e.toString(), true);
                                    });
                                  },
                                  buttonConfirmText: "Xóa",
                                );
                              },
                            );
                          },
                        ),
                      if (isAsigned) ...[
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context1) {
                                      return ConfirmDeleteDialog(
                                        title: "Tạo bản sao công việc",
                                        content:
                                            'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          TaskService()
                                              .cloneTask(task['id'])
                                              .then((value) {
                                            if (value) {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue);
                                              SnackbarShowNoti.showSnackbar(
                                                  "Tạo bản sao thành công!",
                                                  false);
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
                                    },
                                  );
                                },
                                child:
                                    buildIconOption(Icons.copy, "Tạo bản sao")),
                          ],
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
                                        taskCode: task['code']),
                                  ),
                                )
                                .then((value) => {
                                      if (value != null)
                                        {
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue)
                                        }
                                    });
                          },
                          child: buildOptionTask(
                              Icons.task, "Ghi nhận hoạt động", null),
                        ),
                      ] else if (isDoing) ...[
                        Row(
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
                                  _getTasksForSelectedDateAndStatus(
                                      1,
                                      10 * page,
                                      _selectedDate,
                                      groupValue,
                                      true,
                                      searchValue);
                                },
                                child: buildIconOption(
                                    Icons.post_add, "Xem báo cáo"),
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
                                              taskCode: task['code']),
                                        ),
                                      )
                                      .then((value) => {
                                            if (value != null)
                                              {
                                                _getTasksForSelectedDateAndStatus(
                                                    1,
                                                    10 * page,
                                                    _selectedDate,
                                                    groupValue,
                                                    true,
                                                    searchValue)
                                              }
                                          });
                                },
                                child: buildIconOption(
                                    Icons.task, "Ghi nhận hoạt động"),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context1) {
                                        return ConfirmDeleteDialog(
                                          title: "Tạo bản sao công việc",
                                          content:
                                              'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                          onConfirm: () {
                                            Navigator.of(context).pop();
                                            TaskService()
                                                .cloneTask(task['id'])
                                                .then((value) {
                                              if (value) {
                                                _getTasksForSelectedDateAndStatus(
                                                    1,
                                                    10 * page,
                                                    _selectedDate,
                                                    groupValue,
                                                    true,
                                                    searchValue);
                                                SnackbarShowNoti.showSnackbar(
                                                    "Tạo bản sao thành công!",
                                                    false);
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
                                      },
                                    );
                                  },
                                  child: buildIconOption(
                                      Icons.copy, "Tạo bản sao")),
                            ]),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 5,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.pending_actions,
                              'Chuyển sang "Tạm hoãn"', null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 7,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.cancel_outlined,
                              'Công việc bị hủy bỏ', Colors.red),
                        ),
                      ] else if (isCompleted) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                task['isHaveSubtask']
                                    ? Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) => SubTaskPage(
                                              isRecordTime: true,
                                              taskStatus: task['status'],
                                              startDate: task['startDate'],
                                              endDate: task['endDate'],
                                              taskId: task['id'],
                                              taskName: task['name'],
                                              taskCode: task['code']),
                                        ),
                                      )
                                        .then((value) {
                                        if (value != null) {
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      })
                                    : Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TimeKeepingInTask(
                                            codeTask: task['code'],
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
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      });
                              },
                              child:
                                  buildIconOption(Icons.timer, "Xem giờ làm"),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context1) {
                                      return ConfirmDeleteDialog(
                                        title: "Tạo bản sao công việc",
                                        content:
                                            'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          TaskService()
                                              .cloneTask(task['id'])
                                              .then((value) {
                                            if (value) {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue);
                                              SnackbarShowNoti.showSnackbar(
                                                  "Tạo bản sao thành công!",
                                                  false);
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
                                    },
                                  );
                                },
                                child:
                                    buildIconOption(Icons.copy, "Tạo bản sao")),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context1) {
                                return ConfirmDeleteDialog(
                                  title: "Đóng công việc",
                                  content:
                                      "Công việc này sẽ không thể chỉnh sửa được nữa?",
                                  onConfirm: () {
                                    TaskService()
                                        .changeStatusToClose(task['id'])
                                        .then((value) {
                                      if (value) {
                                        removeTask(task['id']);
                                        SnackbarShowNoti.showSnackbar(
                                            "Đã đóng công việc!", false);
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
                              },
                            );
                          },
                          child: buildOptionTask(Icons.file_download_done_sharp,
                              "Đóng công việc", null),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return RejectionReasonPopup(
                                  taskId: task['id'],
                                  isRedo: true,
                                  endDate: task['endDate'],
                                );
                              },
                            ).then((value) {
                              if (value != null) {
                                removeTask(task['id']);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.error,
                              "Công việc chưa đáp ứng", Colors.red),
                        ),
                      ] else if (isPending) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context1) {
                                      return ConfirmDeleteDialog(
                                        title: "Tạo bản sao công việc",
                                        content:
                                            'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          TaskService()
                                              .cloneTask(task['id'])
                                              .then((value) {
                                            if (value) {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue);
                                              SnackbarShowNoti.showSnackbar(
                                                  "Tạo bản sao thành công!",
                                                  false);
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
                                    },
                                  );
                                },
                                child:
                                    buildIconOption(Icons.copy, "Tạo bản sao")),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context1) {
                                  return ConfirmDeleteDialog(
                                    title: "Công việc đang thực hiện",
                                    content:
                                        'Công việc sẽ chuyển sang trạng thái "Đang thực hiện"',
                                    onConfirm: () {
                                      Navigator.of(context).pop();
                                      TaskService()
                                          .changeStatusToDoing(task['id'])
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
                                });
                          },
                          child: buildOptionTask(Icons.change_circle,
                              'Chuyển sang "Đang thực hiện"', null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 7,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.cancel_outlined,
                              'Công việc bị hủy bỏ', Colors.red),
                        ),
                      ] else if (isRejected) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
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
                                      if (value != null) removeTask(task['id'])
                                    });
                              },
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context1) {
                                      return ConfirmDeleteDialog(
                                        title: "Tạo bản sao công việc",
                                        content:
                                            'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          TaskService()
                                              .cloneTask(task['id'])
                                              .then((value) {
                                            if (value) {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue);
                                              SnackbarShowNoti.showSnackbar(
                                                  "Tạo bản sao thành công!",
                                                  false);
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
                                    },
                                  );
                                },
                                child:
                                    buildIconOption(Icons.copy, "Tạo bản sao")),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => UpdateTaskDraftTodoPage(
                                  changeTodo: true,
                                  reDo: true,
                                  task: task,
                                  role: role,
                                ),
                              ),
                            )
                                .then((value) {
                              if (value != null) {
                                Navigator.of(context).pop();
                                removeTask(task['id']);
                              }
                            });
                          },
                          child: buildOptionTask(
                              Icons.change_circle, 'Giao lại', null),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context1) {
                                  return ConfirmDeleteDialog(
                                    title: "Không chấp nhận từ chối công việc",
                                    content:
                                        'Công việc sẽ chuyển sang trạng thái "Chuẩn bị"',
                                    checkBox: true,
                                    onCheckBoxChanged: (value) {
                                      // Callback này được gọi khi giá trị isImportant thay đổi
                                      setState(() {
                                        isImportant = value;
                                      });
                                    },
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
                                });
                          },
                          child: buildOptionTask(Icons.change_circle,
                              'Không chấp nhận từ chối', Colors.red),
                        ),
                      ] else if (isCanceled) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context1) {
                                      return ConfirmDeleteDialog(
                                        title: "Tạo bản sao công việc",
                                        content:
                                            'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          TaskService()
                                              .cloneTask(task['id'])
                                              .then((value) {
                                            if (value) {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue);
                                              SnackbarShowNoti.showSnackbar(
                                                  "Tạo bản sao thành công!",
                                                  false);
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
                                    },
                                  );
                                },
                                child:
                                    buildIconOption(Icons.copy, "Tạo bản sao")),
                          ],
                        ),
                      ] else if (isClosed) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                task['isHaveSubtask']
                                    ? Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) => SubTaskPage(
                                              isRecordTime: true,
                                              taskStatus: task['status'],
                                              startDate: task['startDate'],
                                              endDate: task['endDate'],
                                              taskId: task['id'],
                                              taskName: task['name'],
                                              taskCode: task['code']),
                                        ),
                                      )
                                        .then((value) {
                                        if (value != null) {
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      })
                                    : Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TimeKeepingInTask(
                                            codeTask: task['code'],
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
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      });
                              },
                              child:
                                  buildIconOption(Icons.timer, "Xem giờ làm"),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context1) {
                                      return ConfirmDeleteDialog(
                                        title: "Tạo bản sao công việc",
                                        content:
                                            'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          TaskService()
                                              .cloneTask(task['id'])
                                              .then((value) {
                                            if (value) {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue);
                                              SnackbarShowNoti.showSnackbar(
                                                  "Tạo bản sao thành công!",
                                                  false);
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
                                    },
                                  );
                                },
                                child:
                                    buildIconOption(Icons.copy, "Tạo bản sao")),
                          ],
                        ),
                      ] else
                        Container(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            })
        : showModalBottomSheet(
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
                      if (isPreparing) ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AssignTaskPage(task: task),
                              ),
                            )
                                .then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(
                              Icons.change_circle, "Tiến hành giao việc", null),
                        ),
                        buildDivider(),
                        GestureDetector(
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
                          child: buildOptionTask(Icons.change_circle,
                              "Từ chối công việc", Colors.red),
                        ),
                      ] else if (isAsigned) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.of(context).pop();
                            //     Navigator.of(context)
                            //         .push(
                            //           MaterialPageRoute(
                            //             builder: (context) => SubTaskPage(
                            //                 isRecordTime: false,
                            //                 taskStatus: task['status'],
                            //                 startDate: task['startDate'],
                            //                 endDate: task['endDate'],
                            //                 taskId: task['id'],
                            //                 taskName: task['name'],
                            //                 taskCode: task['code']),
                            //           ),
                            //         )
                            //         .then((value) => {
                            //               if (value != null)
                            //                 {
                            //                   _getTasksForSelectedDateAndStatus(
                            //                       1,
                            //                       10 * page,
                            //                       _selectedDate,
                            //                       groupValue,
                            //                       true,
                            //                       searchValue),
                            //                 }
                            //             });
                            //   },
                            //   child: buildIconOption(
                            //       Icons.task, "Ghi nhận hoạt động"),
                            // ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          task['managerName'] == null
                                              ? UpdateTaskPage(
                                                  role: role,
                                                  task: task,
                                                )
                                              : AssignTaskPage(task: task),
                                    ),
                                  )
                                      .then((value) {
                                    if (value != null) {
                                      _getTasksForSelectedDateAndStatus(
                                          1,
                                          10 * page,
                                          _selectedDate,
                                          groupValue,
                                          true,
                                          searchValue);
                                    }
                                  });
                                },
                                child: buildIconOption(
                                    Icons.edit_square, "Chỉnh sửa")),
                          ],
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context1) {
                                  return ConfirmDeleteDialog(
                                    title: "Công việc đang thực hiện",
                                    content:
                                        'Công việc sẽ chuyển sang trạng thái "Đang thực hiện"',
                                    onConfirm: () {
                                      Navigator.of(context).pop();
                                      TaskService()
                                          .changeStatusToDoing(task['id'])
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
                                });
                          },
                          child: buildOptionTask(Icons.change_circle,
                              'Chuyển sang "Đang thực hiện"', null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 5,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.pending_actions,
                              'Chuyển sang "Tạm hoãn"', null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 7,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.cancel_outlined,
                              'Công việc bị hủy bỏ', Colors.red),
                        ),
                        if (task['managerName'] == null) buildDivider(),
                        if (task['managerName'] == null)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context1) {
                                    return ConfirmDeleteDialog(
                                      title: "Xóa công việc",
                                      content:
                                          'Bạn có chắc muốn xóa công việc này?"',
                                      onConfirm: () {
                                        Navigator.of(context).pop();
                                        TaskService()
                                            .deleteTaskAssign(task['id'])
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
                                  });
                            },
                            child: buildOptionTask(Icons.change_circle,
                                'Xóa công việc', Colors.red),
                          ),
                      ] else if (isDoing) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => EvidencePage(
                                      role: role,
                                      task: task,
                                    ),
                                  ),
                                )
                                    .then((value) {
                                  _getTasksForSelectedDateAndStatus(
                                      1,
                                      10 * page,
                                      _selectedDate,
                                      groupValue,
                                      true,
                                      searchValue);
                                });
                              },
                              child: buildIconOption(
                                  Icons.post_add, "Báo cáo công việc"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AssignTaskPage(task: task),
                                    ),
                                  )
                                      .then((value) {
                                    if (value != null) {
                                      _getTasksForSelectedDateAndStatus(
                                          1,
                                          10 * page,
                                          _selectedDate,
                                          groupValue,
                                          true,
                                          searchValue);
                                    }
                                  });
                                },
                                child: buildIconOption(
                                    Icons.edit_square, "Chỉnh sửa")),
                          ],
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            task['isHaveSubtask']
                                ? Navigator.of(context)
                                    .push(
                                    MaterialPageRoute(
                                      builder: (context) => SubTaskPage(
                                          isRecordTime: true,
                                          taskStatus: task['status'],
                                          startDate: task['startDate'],
                                          endDate: task['endDate'],
                                          taskId: task['id'],
                                          taskName: task['name'],
                                          taskCode: task['code']),
                                    ),
                                  )
                                    .then((value) {
                                    if (value != null) {
                                      _getTasksForSelectedDateAndStatus(
                                          1,
                                          10 * page,
                                          _selectedDate,
                                          groupValue,
                                          true,
                                          searchValue);
                                    }
                                  })
                                : Navigator.of(context)
                                    .push(
                                    MaterialPageRoute(
                                      builder: (context) => TimeKeepingInTask(
                                        codeTask: task['code'],
                                        taskId: task['id'],
                                        taskName: task['name'],
                                        isCreate: true,
                                        status: 0,
                                        task: task,
                                      ),
                                    ),
                                  )
                                    .then((value) {
                                    if (value != null) {
                                      _getTasksForSelectedDateAndStatus(
                                          1,
                                          10 * page,
                                          _selectedDate,
                                          groupValue,
                                          true,
                                          searchValue);
                                    }
                                  });
                          },
                          child: buildOptionTask(
                              Icons.done, 'Chuyển sang "Hoàn thành"', null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 5,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.pending_actions,
                              'Chuyển sang "Tạm hoãn"', null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 7,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.cancel_outlined,
                              'Công việc bị hủy bỏ', Colors.red),
                        ),
                      ] else if (isCompleted) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Báo cáo công việc"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                task['isHaveSubtask']
                                    ? Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) => SubTaskPage(
                                              isRecordTime: true,
                                              taskStatus: task['status'],
                                              startDate: task['startDate'],
                                              endDate: task['endDate'],
                                              taskId: task['id'],
                                              taskName: task['name'],
                                              taskCode: task['code']),
                                        ),
                                      )
                                        .then((value) {
                                        if (value != null) {
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      })
                                    : Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TimeKeepingInTask(
                                            codeTask: task['code'],
                                            taskId: task['id'],
                                            taskName: task['name'],
                                            isCreate: true,
                                            status: 0,
                                            task: task,
                                          ),
                                        ),
                                      )
                                        .then((value) {
                                        if (value != null) {
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      });
                              },
                              child:
                                  buildIconOption(Icons.timer, "Xem giờ làm"),
                            ),
                          ],
                        ),
                      ] else if (isPending) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context1) {
                                  return ConfirmDeleteDialog(
                                    title: "Công việc đang thực hiện",
                                    content:
                                        'Công việc sẽ chuyển sang trạng thái "Đang thực hiện"',
                                    onConfirm: () {
                                      Navigator.of(context).pop();
                                      TaskService()
                                          .changeStatusToDoing(task['id'])
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
                                });
                          },
                          child: buildOptionTask(Icons.change_circle,
                              'Chuyển sang "Đang thực hiện"', null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateEvidencePage(
                                        taskId: task['id'],
                                        status: 7,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                _getTasksForSelectedDateAndStatus(
                                    1,
                                    10 * page,
                                    _selectedDate,
                                    groupValue,
                                    true,
                                    searchValue);
                              }
                            });
                          },
                          child: buildOptionTask(Icons.cancel_outlined,
                              'Công việc bị hủy bỏ', Colors.red),
                        ),
                      ] else if (isRejected) ...[
                        GestureDetector(
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
                          child: buildOptionTask(
                              Icons.change_circle, "Xem báo cáo", null),
                        ),
                        buildDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            cancelRejectTaskStatus(task['id']).then((value) {
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
                          child: buildOptionTask(
                              Icons.change_circle, "Hủy từ chối", Colors.red),
                        ),
                      ] else if (isCanceled) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                          ],
                        ),
                      ] else if (isClosed) ...[
                        Row(
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
                              child: buildIconOption(
                                  Icons.post_add, "Xem báo cáo"),
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
                                            taskCode: task['code']),
                                      ),
                                    )
                                    .then((value) => {
                                          if (value != null)
                                            {
                                              _getTasksForSelectedDateAndStatus(
                                                  1,
                                                  10 * page,
                                                  _selectedDate,
                                                  groupValue,
                                                  true,
                                                  searchValue)
                                            }
                                        });
                              },
                              child: buildIconOption(
                                  Icons.task, "Ghi nhận hoạt động"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                task['isHaveSubtask']
                                    ? Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) => SubTaskPage(
                                              isRecordTime: true,
                                              taskStatus: task['status'],
                                              startDate: task['startDate'],
                                              endDate: task['endDate'],
                                              taskId: task['id'],
                                              taskName: task['name'],
                                              taskCode: task['code']),
                                        ),
                                      )
                                        .then((value) {
                                        if (value != null) {
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      })
                                    : Navigator.of(context)
                                        .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TimeKeepingInTask(
                                            codeTask: task['code'],
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
                                          _getTasksForSelectedDateAndStatus(
                                              1,
                                              10 * page,
                                              _selectedDate,
                                              groupValue,
                                              true,
                                              searchValue);
                                        }
                                      });
                              },
                              child:
                                  buildIconOption(Icons.timer, "Xem giờ làm"),
                            ),
                          ],
                        ),
                      ] else
                        Container(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            });
  }
}
