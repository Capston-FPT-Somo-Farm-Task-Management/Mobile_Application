import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/explosion.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/evidence_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/evidence_add_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/sub_task/sub_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_assign/task_assign_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_draft_todo_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/rejection_reason/rejection_reason_page.dart';
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
  bool isImportant = false;
  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  Future<bool> cancelRejectTaskStatus(int taskId) async {
    return TaskService().cancelRejectTaskStatus(taskId, isImportant);
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
        if (task['status'] == "Bản nháp" && role == "Supervisor") {
          SnackbarShowNoti.showSnackbar(
              "Người quản lí đã hoàn tác công viẹc", true);
          Navigator.of(context).pop();
        }
        dateRepeat = formatDates(task['dateRepeate']);
        isLoading = false;
      });
    }).catchError((e) {
      isLoading = false;
      SnackbarShowNoti.showSnackbar(e.toString(), true);
      Navigator.of(context).pop();
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
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                  onTap: () {
                    // isChange
                    Navigator.of(context).pop("ok");
                    // : Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close_sharp, color: kSecondColor)),
              title: Text(
                "# ${task['code']}",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                role == "Manager" &&
                        task['managerName'] != null &&
                        (task['status'] == "Từ chối" ||
                            task['status'] == "Chuẩn bị" ||
                            task['status'] == "Bản nháp")
                    ? IconButton(
                        icon: const Icon(
                          Icons.mode_edit_outline_outlined,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => UpdateTaskDraftTodoPage(
                                  reDo: false,
                                  changeTodo: false,
                                  task: task,
                                  role: role!),
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
                    : role == "Supervisor" &&
                            (task['status'] == "Đã giao" ||
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
                                          task['managerName'] == null
                                              ? UpdateTaskPage(
                                                  role: role!,
                                                  task: task,
                                                )
                                              : AssignTaskPage(task: task),
                                    ),
                                  )
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {getTask(), isChange = true}
                                    },
                                  );
                            },
                          )
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
                            EdgeInsets.symmetric(horizontal: 27, vertical: 10),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "${task['name']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700,
                                        color: kSecondColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          // TextSpan(
                                          //   text: "Ưu tiên: ",
                                          //   style: TextStyle(
                                          //     fontSize: 18,
                                          //     fontWeight: FontWeight.w700,
                                          //     color: Priority.getBGClr(
                                          //       task['priority'],
                                          //     ),
                                          //   ),
                                          // ),
                                          TextSpan(
                                            text: "${task['priority']}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Priority.getBGClr(
                                                task['priority'],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Center(
                                  child: Text(
                                    "-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: Text(
                                      "${task['status']}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
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
                            if (task['isPlant'] != null)
                              const SizedBox(height: 14),
                            if (task['isPlant'] != null)
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
                                      'Khu vực: ${task['areaName'] ?? "Chưa có"}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['isPlant'] != null)
                              const SizedBox(height: 16),
                            if (task['isPlant'] != null)
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
                                      'Vùng: ${task['zoneName'] ?? "Chưa có"}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['isPlant'] != null)
                              const SizedBox(height: 16),
                            if (task['isPlant'] != null)
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
                                      task['isPlant']
                                          ? 'Vườn: ${task['fieldName'] ?? "Chưa có"}'
                                          : 'Chuồng: ${task['fieldName'] ?? "Chưa có"}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (task['isPlant'] == null)
                              const SizedBox(height: 16),
                            if (task['isPlant'] == null)
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
                                      'Địa chỉ chi tiết: ${(task['addressDetail'].toString().isEmpty || task['addressDetail'] == null ? "Chưa có" : task['addressDetail'])}',
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
                                    'Bắt đầu: ${task['startDate'] == null ? "Chưa có" : '${DateFormat('dd/MM/yyyy   HH:mm').format(DateTime.parse(task['startDate']))}'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (task['isStartLate'] == true)
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: CustomPaint(
                                      painter: ExplosionPainter(),
                                      child: Container(
                                        width: 25,
                                        height: 23,
                                        color: Colors.amber,
                                        child: Center(
                                          child: Text(
                                            "Trễ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
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
                                    'Kết thúc: ${task['endDate'] == null ? "Chưa có" : '${DateFormat('dd/MM/yyyy   HH:mm').format(DateTime.parse(task['endDate']))}'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (task['isExpired'])
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: CustomPaint(
                                      painter: ExplosionPainter(),
                                      child: Container(
                                        width: 25,
                                        height: 23,
                                        color: Colors.amber,
                                        child: Center(
                                          child: Text(
                                            "Trễ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (task['status'] != "Bản nháp" &&
                                task['status'] != "Chuẩn bị")
                              SizedBox(height: 16),
                            if (task['status'] != "Bản nháp" &&
                                task['status'] != "Chuẩn bị")
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
                      if (task['isPlant'] != null && task['isSpecific'])
                        const SizedBox(height: 10),
                      if (task['isPlant'] != null && task['isSpecific'])
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (task['isPlant'] != null) ...[
                                Text(
                                  "Đối tượng",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 14),
                              ] else
                                Container(),
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
                                      task['isPlant']
                                          ? 'Cây trồng: ${task['plantName'] ?? "Chưa có"}'
                                          : 'Con vật: ${task['liveStockName'] ?? "Chưa có"}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (task['isSpecific'])
                                const SizedBox(height: 16),
                              if (task['isSpecific'])
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
                                        task['isPlant']
                                            ? 'Mã cây: ${task['externalId'] ?? "Chưa có"}'
                                            : 'Mã con vật: ${task['externalId'] ?? "Chưa có"}',
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
                      if (task['status'] != "chuẩn bị") SizedBox(height: 10),
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
                                    'Người giám sát: ${task['supervisorName'] ?? "Chưa có"}',
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
                                      'Người thực hiện: ${task['employeeName'] == null || task['employeeName'].toString().isEmpty ? "Chưa có" : task['employeeName']}',
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
                                    'Loại công việc: ${task['taskTypeName'] ?? "Chưa có"}',
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
            top: BorderSide(width: 0.2, color: Colors.grey),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: role == "Manager"
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Status bản nháp -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Bản nháp")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status bản nháp -> Manager bấm chuyển sang chuẩn bị
                    if (task['status'] == "Bản nháp") SizedBox(width: 10),
                    if (task['status'] == "Bản nháp")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateTaskDraftTodoPage(
                                      reDo: false,
                                      changeTodo: true,
                                      task: task,
                                      role: role!),
                                ),
                              )
                              .then(
                                (value) => {
                                  if (value != null)
                                    {getTask(), isChange = true}
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
                        child: Text("Chuẩn bị"),
                      ),

                    // Status bản nháp -> Manager bấm xóa công việc
                    if (task['status'] == "Bản nháp") SizedBox(width: 10),
                    if (task['status'] == "Bản nháp")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Xóa công việc",
                                content: "Bạn có chắc muốn xóa công việc này?",
                                onConfirm: () {
                                  deleteTask(task['id']).then((value) {
                                    if (value) {
                                      Navigator.of(context).pop("ok");
                                      removeTask(task['id']);
                                      // isChange = true;
                                      // getTask();
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
                        child: Text("Xóa"),
                      ),

                    // Status chuẩn bị -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Chuẩn bị")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status chuẩn bị -> Manager bấm sang status bản nháp
                    if (task['status'] == "Chuẩn bị") SizedBox(width: 10),
                    if (task['status'] == "Chuẩn bị")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Đổi trạng thái",
                                content: 'Chuyển công việc sang "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .updateStatusFromTodoToDraft(task['id'])
                                      .then((value) {
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
                        child: Text("Bản nháp"),
                      ),

                    // Status chuẩn bị -> Manager bấm xóa công việc
                    if (task['status'] == "Chuẩn bị") SizedBox(width: 10),
                    if (task['status'] == "Chuẩn bị")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Xóa công việc",
                                content: "Bạn có chắc muốn xóa công việc này?",
                                onConfirm: () {
                                  deleteTask(task['id']).then((value) {
                                    if (value) {
                                      Navigator.of(context).pop("ok");
                                      removeTask(task['id']);
                                      // isChange = true;
                                      // getTask();
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
                        child: Text("Xóa"),
                      ),

                    // Status đã giao -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Đã giao")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status đã giao -> Manager bấm xem hoạt động
                    if (task['status'] == "Đã giao") SizedBox(width: 10),
                    if (task['status'] == "Đã giao")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status đang thực hiện -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status đang thực hiện -> Manager bấm xem báo cáo
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
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

                    // Status đang thực hiện -> Manager bấm xem hoạt động
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status đang thực hiện -> Manager bấm tạm hoãn công việc
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateEvidencePage(
                                      taskId: task['id'],
                                      status: 5,
                                    )),
                          ).then((value) {
                            if (value != null) {
                              isChange = true;
                              getTask();
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(100, 50)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text("Tạm hoãn"),
                      ),

                    // Status đang thực hiện -> Manager đổi status sang hủy bỏ công việc
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEvidencePage(
                                taskId: task['id'],
                                status: 7,
                              ),
                            ),
                          ).then(
                            (value) => {
                              if (value != null) {getTask(), isChange = true},
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
                        child: Text("Hủy bỏ"),
                      ),

                    // Status hoàn thành -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status hoàn thành -> Manager bấm xem giờ làm
                    if (task['status'] == "Hoàn thành") SizedBox(width: 10),
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
                          task['isHaveSubtask']
                              // Chấm giờ công nếu không có hoạt động
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
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
                                    },
                                  )
                              // Xác nhận lại giờ công nếu đã có hoạt động
                              : Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => TimeKeepingInTask(
                                        codeTask:
                                            task['code'] ?? task['codeTask'],
                                        taskId: task['id'],
                                        taskName: task['name'],
                                        isCreate: true,
                                        status: 0,
                                        task: task,
                                      ),
                                    ),
                                  )
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
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
                        child: Text("Xem giờ làm"),
                      ),

                    // Status đang thực hiện -> Manager bấm xem hoạt động
                    if (task['status'] == "Hoàn thành") SizedBox(width: 10),
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status hoàn thành -> Manager bấm xem báo cáo
                    if (task['status'] == "Hoàn thành") SizedBox(width: 10),
                    if (task['status'] == "Hoàn thành")
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

                    // Status hoàn thành -> Manager bấm làm lại công việc
                    if (task['status'] == "Hoàn thành") SizedBox(width: 10),
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
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
                              getTask();
                              isChange = true;
                            }
                          });
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
                        child: Text("Làm lại"),
                      ),

                    // Status hoàn thành -> Manager bấm đóng công việc
                    if (task['status'] == "Hoàn thành") SizedBox(width: 10),
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
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
                                      getTask();
                                      isChange = true;
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
                        child: Text("Đóng"),
                      ),

                    // Status tạm hoãn -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status tạm hoãn -> Manager bấm xem hoạt động
                    if (task['status'] == "Tạm hoãn") SizedBox(width: 10),
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status tạm hoãn -> Manager bấm xem báo cáo
                    if (task['status'] == "Tạm hoãn") SizedBox(width: 10),
                    if (task['status'] == "Tạm hoãn")
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

                    // Status tạm hoãn -> Manager bấm chuyển sang đang thực hiện
                    if (task['status'] == "Tạm hoãn") SizedBox(width: 10),
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Đổi trạng thái",
                                content:
                                    'Chuyển công việc sang "Đang thực hiện"',
                                onConfirm: () {
                                  TaskService()
                                      .changeStatusToDoing(task['id'])
                                      .then((value) {
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

                    // Status tạm hoãn -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status tạm hoãn -> Manager  đổi status sang hủy bỏ công việc
                    if (task['status'] == "Tạm hoãn") SizedBox(width: 10),
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEvidencePage(
                                taskId: task['id'],
                                status: 7,
                              ),
                            ),
                          ).then(
                            (value) => {
                              if (value != null) {getTask(), isChange = true},
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
                        child: Text("Hủy bỏ"),
                      ),

                    // Status từ chối -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Từ chối")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status từ chối -> Manager bấm giao lại lại công việc
                    if (task['status'] == "Từ chối") SizedBox(width: 10),
                    if (task['status'] == "Từ chối")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateTaskDraftTodoPage(
                                    changeTodo: true,
                                    reDo: true,
                                    task: task,
                                    role: role!,
                                  ),
                                ),
                              )
                              .then(
                                (value) => {
                                  if (value != null) {getTask()}
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
                        child: Text("Giao lại"),
                      ),

                    //Status từ chối -> Manager bấm xem báo cáo tại sao từ chối
                    if (task['status'] == "Từ chối") SizedBox(width: 10),
                    if (task['status'] == "Từ chối")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ViewRejectionReasonPopup(
                                role: role!,
                                task: task,
                              );
                            },
                          ).then(
                            (value) => {
                              if (value != null) {getTask()}
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
                        child: Text("Xem báo cáo"),
                      ),

                    // Status từ chối -> Manager bấm không chấp nhận từ chối
                    if (task['status'] == "Từ chối") SizedBox(width: 10),
                    if (task['status'] == "Từ chối")
                      ElevatedButton(
                        onPressed: () {
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
                                    cancelRejectTaskStatus(task['id'])
                                        .then((value) {
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
                              });
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
                        child: Text("Không chấp nhận từ chối"),
                      ),

                    // Status hủy bỏ -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Hủy bỏ")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status hùy bỏ -> Manager bấm xem báo cáo
                    if (task['status'] == "Hủy bỏ") SizedBox(width: 10),
                    if (task['status'] == "Hủy bỏ")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status hùy bỏ -> Manager bấm xem hoạt động
                    if (task['status'] == "Hủy bỏ") SizedBox(width: 10),
                    if (task['status'] == "Hủy bỏ")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => EvidencePage(
                                    role: role!,
                                    task: task,
                                  ),
                                ),
                              )
                              .then((value) => {
                                    if (value != null)
                                      {getTask(), isChange = true}
                                  });
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

                    // Status đã đóng -> Manager bấm chuyển tạo bản saoo
                    if (task['status'] == "Đã đóng")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Tạo bản sao công việc",
                                content:
                                    'Bản sao công việc sẽ được tạo ở trạng thái "Bản nháp"',
                                onConfirm: () {
                                  TaskService()
                                      .cloneTask(task['id'])
                                      .then((value) {
                                    if (value) {
                                      getTask();
                                      isChange = true;
                                      SnackbarShowNoti.showSnackbar(
                                          "Tạo bản sao thành công!", false);
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
                        child: Text("Tạo bản sao"),
                      ),

                    // Status đã đóng -> Manager bấm xem báo cáo
                    if (task['status'] == "Đã đóng") SizedBox(width: 10),
                    if (task['status'] == "Đã đóng")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status đóng -> Manager bấm xem báo cáo
                    if (task['status'] == "Đã đóng") SizedBox(width: 10),
                    if (task['status'] == "Đã đóng")
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

                    // Status đóng -> Manager bấm xem giờ làm
                    if (task['status'] == "Đã đóng") SizedBox(width: 10),
                    if (task['status'] == "Đã đóng")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
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
                        child: Text("Xem giờ làm"),
                      ),
                  ],
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Status chuẩn bị -> Supervisor đổi status sang giao việc
                    if (task['status'] == "Chuẩn bị" &&
                        task['managerName'] != null)
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AssignTaskPage(task: task),
                                ),
                              )
                              .then((value) => {
                                    if (value != null)
                                      {
                                        getTask(),
                                        isChange = true,
                                      }
                                  });
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
                        child: Text("Giao công việc"),
                      ),

                    // Status chuẩn bị -> Supervisor từ chối
                    if (task['status'] == "Chuẩn bị") SizedBox(width: 10),
                    if (task['status'] == "Chuẩn bị" &&
                        task['managerName'] != null)
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RejectionReasonPopup(
                                taskId: task['id'],
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              isChange = true;
                              removeTask(task['id']);
                              getTask();
                            }
                          });
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
                        child: Text("Từ chối"),
                      ),

                    // Status đã giao -> Supervisor bấm tạo hoạt động
                    if (task['status'] == "Đã giao") SizedBox(width: 10),
                    if (task['status'] == "Đã giao")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
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
                        child: Text("Ghi nhận hoạt động"),
                      ),

                    // Status đã giao -> Supervisor bấm chuyển sang đang thực hiện
                    if (task['status'] == "Đã giao") SizedBox(width: 10),
                    if (task['status'] == "Đã giao")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Đổi trạng thái",
                                content:
                                    'Chuyển công việc sang "Đang thực hiện"',
                                onConfirm: () {
                                  TaskService()
                                      .changeStatusToDoing(task['id'])
                                      .then((value) {
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

                    // Status đã giao -> Supervisor đổi status sang tạm hoãn
                    if (task['status'] == "Đã giao") SizedBox(width: 10),
                    if (task['status'] == "Đã giao")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateEvidencePage(
                                      taskId: task['id'],
                                      status: 5,
                                    )),
                          ).then((value) {
                            if (value != null) {
                              isChange = true;
                              getTask();
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(100, 50)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text("Tạm hoãn"),
                      ),

                    // Status đã giao -> Supervisor đổi status sang hủy bỏ công việc
                    if (task['status'] == "Đã giao") SizedBox(width: 10),
                    if (task['status'] == "Đã giao" &&
                        task['managerName'] == null)
                      SizedBox(width: 10),
                    if (task['status'] == "Đã giao")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEvidencePage(
                                taskId: task['id'],
                                status: 7,
                              ),
                            ),
                          ).then(
                            (value) => {
                              if (value != null) {getTask(), isChange = true},
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
                        child: Text("Hủy bỏ"),
                      ),

                    // Status đã giao -> Supervisor bấm xóa công việc
                    if (task['status'] == "Đã giao" &&
                        task['managerName'] == null)
                      SizedBox(width: 10),
                    if (task['status'] == "Đã giao" &&
                        task['managerName'] == null)
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Xóa công việc",
                                content: "Bạn có chắc muốn xóa công việc này?",
                                onConfirm: () {
                                  TaskService()
                                      .deleteTaskAssign(task['id'])
                                      .then((value) {
                                    if (value) {
                                      Navigator.of(context).pop("ok");
                                      removeTask(task['id']);
                                      // isChange = true;
                                      // getTask();
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
                        child: Text("Xóa"),
                      ),

                    // Status đang thực hiện -> Supervisor bấm xem hoạt động
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status đang thực hiện -> Supervisor đổi status sang hoàn thành
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
                          task['isHaveSubtask']
                              // Chấm giờ công nếu không có hoạt động
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
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
                                    },
                                  )
                              // Xác nhận lại giờ công nếu đã có hoạt động
                              : Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => TimeKeepingInTask(
                                        codeTask:
                                            task['code'] ?? task['codeTask'],
                                        taskId: task['id'],
                                        taskName: task['name'],
                                        isCreate: true,
                                        status: 0,
                                        task: task,
                                      ),
                                    ),
                                  )
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
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
                        child: Text("Hoàn thành"),
                      ),

                    // Status đang thực hiện -> Supervisor bấm xem báo cáo
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
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

                    // Status đang thực hiện -> Supervisor đổi status sang tạm hoãn
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateEvidencePage(
                                      taskId: task['id'],
                                      status: 5,
                                    )),
                          ).then((value) {
                            if (value != null) {
                              isChange = true;
                              getTask();
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(100, 50)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text("Tạm hoãn"),
                      ),

                    // Status đang thực hiện -> Supervisor đổi status sang hủy bỏ công việc
                    if (task['status'] == "Đang thực hiện") SizedBox(width: 10),
                    if (task['status'] == "Đang thực hiện")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEvidencePage(
                                taskId: task['id'],
                                status: 7,
                              ),
                            ),
                          ).then(
                            (value) => {
                              if (value != null) {getTask(), isChange = true},
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
                        child: Text("Hủy bỏ"),
                      ),

                    // Status hoàn thành -> Supervisor bấm xem hoạt động
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status hoàn thành -> Supervisor báo cáo công việc
                    if (task['status'] == "Hoàn thành") SizedBox(width: 10),
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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

                    // Status hoàn thành -> Supervisor bấm xem giờ làm của nhân viên
                    if (task['status'] == "Hoàn thành") SizedBox(width: 10),
                    if (task['status'] == "Hoàn thành")
                      ElevatedButton(
                        onPressed: () {
                          task['isHaveSubtask']
                              // Chấm giờ công nếu không có hoạt động
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
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
                                    },
                                  )
                              // Xác nhận lại giờ công nếu đã có hoạt động
                              : Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => TimeKeepingInTask(
                                        codeTask:
                                            task['code'] ?? task['codeTask'],
                                        taskId: task['id'],
                                        taskName: task['name'],
                                        isCreate: true,
                                        status: 0,
                                        task: task,
                                      ),
                                    ),
                                  )
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
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
                        child: Text("Xem giờ làm"),
                      ),

                    // Status tạm hoãn -> Supervisor bấm tạo hoạt động
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
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
                                      {getTask(), isChange = true}
                                  });
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
                        child: Text("Xem hoạt động"),
                      ),

                    // Status tạm hoãn -> Supervisor bấm xem báo cáo
                    if (task['status'] == "Tạm hoãn") SizedBox(width: 10),
                    if (task['status'] == "Tạm hoãn")
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

                    // Status tạm hoãn -> Supervisor bấm chuyển sang đang thực hiện
                    if (task['status'] == "Tạm hoãn") SizedBox(width: 10),
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context1) {
                              return ConfirmDeleteDialog(
                                title: "Đổi trạng thái",
                                content:
                                    'Chuyển công việc sang "Đang thực hiện"',
                                onConfirm: () {
                                  TaskService()
                                      .changeStatusToDoing(task['id'])
                                      .then((value) {
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

                    // Status tạm hoãn -> Supervisor đổi status sang hủy bỏ công việc
                    if (task['status'] == "Tạm hoãn") SizedBox(width: 10),
                    if (task['status'] == "Tạm hoãn")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEvidencePage(
                                taskId: task['id'],
                                status: 7,
                              ),
                            ),
                          ).then(
                            (value) => {
                              if (value != null) {getTask(), isChange = true},
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
                        child: Text("Hủy bỏ"),
                      ),

                    //Status từ chối -> Supervisor bấm xem báo cáo từ chối của mình
                    if (task['status'] == "Từ chối")
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ViewRejectionReasonPopup(
                                role: role!,
                                task: task,
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
                        child: Text("Xem báo cáo"),
                      ),

                    // Status từ chối -> Supervisor Bấm hủy từ chối
                    if (task['status'] == "Từ chối") SizedBox(width: 10),
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

                    // Status hủy bỏ -> Supervisor bấm xem báo cáo
                    if (task['status'] == "Hủy bỏ")
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

                    // Status hủy bỏ -> Supervisor bấm tạo hoạt động
                    if (task['status'] == "Hủy bỏ") SizedBox(width: 10),
                    if (task['status'] == "Hủy bỏ")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
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
                        child: Text("Ghi nhận hoạt động"),
                      ),

                    // Status đã đóng -> Supervisor bấm xem báo cáo
                    if (task['status'] == "Đã đóng")
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

                    // Status đã đóng -> Supervisor bấm xem giờ làm của nhân viên
                    if (task['status'] == "Đã đóng") SizedBox(width: 10),
                    if (task['status'] == "Đã đóng")
                      ElevatedButton(
                        onPressed: () {
                          task['isHaveSubtask']
                              // Chấm giờ công nếu không có hoạt động
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
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
                                    },
                                  )
                              // Xác nhận lại giờ công nếu đã có hoạt động
                              : Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => TimeKeepingInTask(
                                        codeTask:
                                            task['code'] ?? task['codeTask'],
                                        taskId: task['id'],
                                        taskName: task['name'],
                                        isCreate: true,
                                        status: 0,
                                        task: task,
                                      ),
                                    ),
                                  )
                                  .then(
                                    (value) => {
                                      if (value != null)
                                        {
                                          getTask(),
                                          isChange = true,
                                        }
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
                        child: Text("Xem giờ làm"),
                      ),

                    // Status đã đóng -> Supervisor bấm tạo hoạt động
                    if (task['status'] == "Đã đóng") SizedBox(width: 10),
                    if (task['status'] == "Đã đóng")
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
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
                        child: Text("Ghi nhận hoạt động"),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
