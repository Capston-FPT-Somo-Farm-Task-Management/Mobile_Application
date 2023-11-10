import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/time_keeping/time_keeping_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/view_rejection_reason/view_rejection_reason_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetailsPage extends StatefulWidget {
  final int taskId;

  const TaskDetailsPage({super.key, required this.taskId});
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Map<String, dynamic> task;
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;
  String? role;
  String? dateRepeat;
  bool isChange = false;
  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  Future<bool> cancelRejectTaskStatus(int taskId) async {
    return TaskService().cancelRejectTaskStatus(taskId);
  }

  Future<bool> changeTaskStatus(int taskId, int newStatus) async {
    return TaskService().changeTaskStatus(taskId, newStatus);
  }

  Future<bool> deleteTask(int taskId) async {
    return TaskService().deleteTask(taskId);
  }

  void removeTask(int taskId) {
    setState(() {
      tasks.removeWhere((task) => task['id'] == taskId);
    });
  }

  String formatDates(List<dynamic> dateStrings) {
    List<DateTime> dateTimes = dateStrings.map((dynamic dateString) {
      return DateTime.parse(dateString);
    }).toList();

    List<String> formattedDates = dateTimes.map((DateTime dateTime) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }).toList();

    return formattedDates.join(', ');
  }

  Future<void> getTask() async {
    await TaskService().getTasksByTaskId(widget.taskId).then((value) {
      setState(() {
        task = value;
        dateRepeat = formatDates(task['dateRepeate']);
        isLoading = false;
      });
    }).catchError((e) {
      isLoading = false;
      SnackbarShowNoti.showSnackbar(e.toString(), true);
    });
  }

  @override
  void initState() {
    super.initState();
    getTask();
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // API hasn't been called yet, return a loading indicator or empty container
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: kPrimaryColor),
        ),
      );
    }

    if (task['status'] == "Đã xóa") {
      // Task is deleted, close the screen and show a notification
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pop();
        SnackbarShowNoti.showSnackbar(
            "Công việc đã bị xóa bởi người tạo", true);
      });
      // Return an empty container as the UI won't be shown
      return Container();
    }
    return Scaffold(
      appBar: isLoading
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                  onTap: () {
                    isChange
                        ? Navigator.of(context).pop("ok")
                        : Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close_sharp, color: kSecondColor)),
              title: Text("# ${task['code']}",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              centerTitle: true,
              actions: [
                role == "Manager" && task['managerName'] != null ||
                        role != "Manager" && task['managerName'] == null
                    ? (task['status'] == "Từ chối" ||
                            task['status'] == "Chuẩn bị" ||
                            task['status'] == "Đang thực hiện")
                        ? IconButton(
                            icon: const Icon(
                              Icons.mode_edit_outline_outlined,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateTaskPage(task: task, role: role!),
                                ),
                              )
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    isLoading = true;
                                    isChange = true;
                                  });
                                  getTask();
                                }
                              });
                            },
                          )
                        : Container()
                    : Container()
              ],
            ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : Container(
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                "${task['name']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                    color: kSecondColor),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "${task['priority']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Priority.getBGClr(
                                            task['priority'])),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    " - ${task['status']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Priority.getBGClr(
                                            task['priority'])),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Text(
                              "Nơi thực hiện",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            if (task['areaName'] != null)
                              const SizedBox(height: 14),
                            if (task['areaName'] != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.mapPin,
                                    color: kSecondColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Khu vực: ${task['areaName']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['zoneName'] != null)
                              const SizedBox(height: 16),
                            if (task['zoneName'] != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.borderNone,
                                    color: kSecondColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Vùng: ${task['zoneName']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['fieldName'] != null)
                              const SizedBox(height: 16),
                            if (task['fieldName'] != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.business,
                                    color: kSecondColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Chuồng: ${task['fieldName']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['addressDetail'] != null)
                              const SizedBox(height: 16),
                            if (task['addressDetail'] != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.description_sharp,
                                    color: kSecondColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Địa chỉ chi tiết: ${task['addressDetail']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Thời gian",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 14),
                            if (task['updateDate'] != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: kSecondColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Ngày chỉnh sửa: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(task['updateDate']))}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['updateDate'] != null)
                              const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(task['createDate']))}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Bắt đầu: ${DateFormat('dd/MM/yyyy - HH:mm a').format(DateTime.parse(task['startDate']))}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Kết thúc: ${DateFormat('dd/MM/yyyy - HH:mm a').format(DateTime.parse(task['endDate']))}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.timer_rounded,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Thời gian làm việc dự kiến phải bỏ ra: ${task['overallEffortHour']} giờ ${task['overallEfforMinutes']} phút',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (task['plantName'] != null ||
                          task['liveStockName'] != null)
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (task['plantName'] != null ||
                                  task['liveStockName'] != null) ...[
                                Text(
                                  "Đối tượng",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 14),
                              ] else
                                Container(),
                              if (task['plantName'] != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.home,
                                      color: kSecondColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Cây: ${task['plantName']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (task['plantName'] != null)
                                const SizedBox(height: 16),
                              if (task['plantName'] != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.tag,
                                      color: kSecondColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Mã cây: ${task['externalId']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (task['liveStockName'] != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.home,
                                      color: kSecondColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Con vật: ${task['liveStockName']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (task['liveStockName'] != null)
                                const SizedBox(height: 16),
                              if (task['liveStockName'] != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.tag,
                                      color: kSecondColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Mã con vật: ${task['externalId']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Mô tả",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  task['description'].toString().trim().isEmpty
                                      ? "Không có mô tả"
                                      : task['description'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Phụ trách",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            if (task['managerName'] != null)
                              const SizedBox(height: 14),
                            if (task['managerName'] != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.person_4_sharp,
                                    color: kSecondColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Người quản lí: ${task['managerName']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Người giám sát: ${task['supervisorName']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Tooltip(
                              message: task['employeeNameCode'],
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.people_outline,
                                    color: kSecondColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Người thực hiện: ${task['employeeName']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Dụng cụ thực hiện",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.handyman_outlined,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Dụng cụ: ${task['materialName'].toString().trim().isEmpty ? 'Không có' : task['materialName']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Loại công việc",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.work,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Loại công việc: ${task['taskTypeName']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Thông báo công việc",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.notifications,
                                  color: kSecondColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    task['remind'] == 0
                                        ? 'Nhắc nhở trước khi bắt đầu: Không'
                                        : 'Nhắc nhở: ${task['remind']} phút trước khi bắt đầu',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (task['isParent'])
                              Row(
                                children: [
                                  const Icon(
                                    Icons.repeat,
                                    color: kSecondColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Lặp lại: ${task['isRepeat'] ? "Có" : "Không"}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['isParent']) const SizedBox(height: 14),
                            if (task['isRepeat'] && task['isParent'])
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event_repeat,
                                    color: kSecondColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Ngày lặp lại: $dateRepeat',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['isRepeat'] && task['isParent'])
                              const SizedBox(height: 16),
                            if (!task['isParent']) const SizedBox(height: 16),
                            if (!task['isParent'])
                              Row(
                                children: [
                                  const Icon(
                                    Icons.repeat,
                                    color: kSecondColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Công việc được lặp lại từ công việc trước đó",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 0.7, color: Colors.grey),
          ),
        ),
        child: role == "Manager"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Từ chối -> Chỉnh sửa
                  if (task['status'] == "Từ chối")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UpdateTaskPage(
                              role: role!,
                              task: task,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Chỉnh sửa"),
                    ),
                  SizedBox(width: 10),
                  //Từ chối -> xem báo cáo
                  if (task['status'] == "Từ chối")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewRejectionReasonPopup(
                              role: role!,
                              task: task,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: role == "Manager"
                          ? Text("Xem báo cáo")
                          : Text("Báo cáo"),
                    ),
                  SizedBox(width: 10),
                  // Xem báo cáo
                  if (task['status'] == "Chuẩn bị" ||
                      task['status'] == "Đang thực hiện" ||
                      task['status'] == "Hoàn thành" ||
                      task['status'] == "Không hoàn thành")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EvidencePage(
                              role: role!,
                              task: task,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Xem báo cáo"),
                    ),
                  SizedBox(width: 10),
                  // Đánh giá
                  if (task['status'] == "Hoàn thành")
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Đánh giá"),
                    ),
                  SizedBox(width: 10),
                  // Chấm công
                  if (task['status'] == "Hoàn thành" ||
                      task['status'] == "Không hoàn thành")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TimeKeepingInTask(
                              codeTask: task['code'],
                              taskId: task['id'],
                              taskName: task['name'],
                              isCreate: false,
                              status: 0,
                              endDateTask: task['endDate'],
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Chấm công"),
                    ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Từ chối -> Chỉnh sửa
                  if (task['status'] == "Từ chối")
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context1) {
                            return ConfirmDeleteDialog(
                              title: "Hủy từ chối",
                              content:
                                  'Công việc sẽ chuyển sang trạng thái "Chuẩn bị"',
                              onConfirm: () {
                                setState(() {
                                  cancelRejectTaskStatus(task['id']).then(
                                    (value) {
                                      if (value) {
                                        getTask();
                                        isChange = true;
                                        SnackbarShowNoti.showSnackbar(
                                            "Đổi thành công!", false);
                                      } else {
                                        SnackbarShowNoti.showSnackbar(
                                            "Xảy ra lỗi!", true);
                                      }
                                    },
                                  );
                                });
                              },
                              buttonConfirmText: "Đồng ý",
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Hủy từ chối"),
                    ),
                  SizedBox(width: 10),

                  //Từ chối -> xem báo cáo
                  if (task['status'] == "Từ chối")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewRejectionReasonPopup(
                              role: role!,
                              task: task,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Xem báo cáo"),
                    ),

                  // Đổi trạng thái thành hoàn thành
                  if (task['status'] == "Đang thực hiện")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TimeKeepingInTask(
                              codeTask: task['code'],
                              taskId: task['id'],
                              taskName: task['name'],
                              isCreate: false,
                              status: 0,
                              endDateTask: task['endDate'],
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text(" Không hoàn thành"),
                    ),

                  SizedBox(width: 10),

                  // Đổi trạng thái thành hoàn thành
                  if (task['status'] == "Đang thực hiện")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TimeKeepingInTask(
                              codeTask: task['code'],
                              taskId: task['id'],
                              taskName: task['name'],
                              isCreate: false,
                              status: 0,
                              endDateTask: task['endDate'],
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Hoàn thành"),
                    ),

                  // Xem báo cáo
                  if (task['status'] == "Chuẩn bị" ||
                      task['status'] == "Đang thực hiện" ||
                      task['status'] == "Hoàn thành" ||
                      task['status'] == "Không hoàn thành")
                    SizedBox(width: 10),
                  if (task['status'] == "Chuẩn bị" ||
                      task['status'] == "Đang thực hiện" ||
                      task['status'] == "Hoàn thành" ||
                      task['status'] == "Không hoàn thành")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EvidencePage(
                              role: role!,
                              task: task,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Báo cáo"),
                    ),

                  // Đổi status sang đang thực hiện
                  if (task['status'] == "Chuẩn bị") SizedBox(width: 10),
                  if (task['status'] == "Chuẩn bị" &&
                      task['managerName'] != null &&
                      DateTime.now()
                          .add(Duration(minutes: 30))
                          .isBefore(DateTime.parse(task['startDate'])))
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context1) {
                            return ConfirmDeleteDialog(
                              title: "Đổi trạng thái",
                              content: 'Chuyển công việc sang "Đang thực hiện"',
                              onConfirm: () {
                                changeTaskStatus(task['id'], 1).then((value) {
                                  if (value) {
                                    getTask();
                                    isChange = true;
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
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Đang thực hiện"),
                    ),
                  if (task['status'] == "Chuẩn bị") SizedBox(width: 10),

                  // Đánh giá
                  if (task['status'] == "Hoàn thành")
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Đánh giá"),
                    ),

                  SizedBox(width: 10),
                  // Chấm công
                  if (task['status'] == "Hoàn thành" ||
                      task['status'] == "Không hoàn thành")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TimeKeepingInTask(
                              taskId: task['id'],
                              codeTask: task['code'],
                              taskName: task['name'],
                              isCreate: false,
                              status: 0,
                              endDateTask: task['endDate'],
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text("Chấm công"),
                    ),
                ],
              ),
      ),
    );
  }
}
