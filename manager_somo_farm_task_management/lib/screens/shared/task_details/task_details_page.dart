import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
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
              title: Text(task['name'], style: TextStyle(color: kPrimaryColor)),
              centerTitle: true,
              actions: [
                role == "Manager" && task['managerName'] != null ||
                        role != "Manager" && task['managerName'] == null
                    ? (task['status'] == "Từ chối" ||
                            task['status'] == "Chuẩn bị" ||
                            task['status'] == "Đang thực hiện")
                        ? task['isParent'] && task['isRepeat']
                            ? IconButton(
                                icon: const Icon(
                                  Icons.mode_edit_outline_outlined,
                                  color: kPrimaryColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => UpdateTaskPage(
                                          task: task, role: role!),
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
                    : Container(),
              ],
            ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          task['description'].toString().trim().isEmpty
                              ? "Không có mô tả"
                              : task['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    if (task['plantName'] != null) const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                            'Bắt đầu: ${DateFormat('HH:mm a  -  dd/MM/yyyy').format(DateTime.parse(task['startDate']))}',
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
                            'kết thúc: ${DateFormat('HH:mm a  -  dd/MM/yyyy').format(DateTime.parse(task['endDate']))}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (task['managerName'] != null) const SizedBox(height: 16),
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
                              'Thực hiện: ${task['employeeName']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.priority_high,
                          color: kSecondColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Ưu tiên: ${task['priority']}',
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
                    const SizedBox(height: 16),
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
                    if (task['isParent']) const SizedBox(height: 16),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: kSecondColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Trạng thái: ${task['status']}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
