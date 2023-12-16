import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/effort_service.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeKeepingInTask extends StatefulWidget {
  final int taskId;
  final String taskName;
  final bool isCreate;
  final int status;
  final String codeTask;
  final Map<String, dynamic> task;
  TimeKeepingInTask(
      {required this.taskId,
      required this.taskName,
      required this.isCreate,
      required this.status,
      required this.codeTask,
      required this.task});

  @override
  State<TimeKeepingInTask> createState() => _TimeKeepingInTaskState();
}

class _TimeKeepingInTaskState extends State<TimeKeepingInTask> {
  List<String> _selectedDate = [];
  bool isLoading = true;
  List<Map<String, dynamic>> employees = [];
  List<TextEditingController> controllers = [];
  List<TextEditingController> _minutesController = [];
  List<TextEditingController> _hoursController = [];
  bool isSaveEnabled = false;
  String? role;
  bool? isHaveSubtask;
  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  void getEmployees() {
    EffortService().getEffortByTaskId(widget.taskId).then((value) {
      setState(() {
        _minutesController.clear();
        _hoursController.clear();
        employees = List<Map<String, dynamic>>.from(value['subtasks']);

        isHaveSubtask = value['isHaveSubtask'];
        if (isHaveSubtask!) isSaveEnabled = true;
        for (int i = 0; i < employees.length; i++) {
          TextEditingController minutesController = TextEditingController(
              text: employees[i]['totalActualEfforMinutes'].toString() == "0"
                  ? ""
                  : employees[i]['totalActualEfforMinutes'].toString());
          TextEditingController hoursController = TextEditingController(
              text: employees[i]['totalActualEffortHour'].toString() == "0"
                  ? ""
                  : employees[i]['totalActualEffortHour'].toString());
          if (value['subtasks'][i]['daySubmit'] != null)
            _selectedDate.add(DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(value['subtasks'][i]['daySubmit'])));
          else
            _selectedDate.add("");
          _minutesController.add(minutesController);
          _hoursController.add(hoursController);
        }

        isLoading = false;
      });
    });
  }

  Future<bool> createEffort(List<Map<String, dynamic>> data) {
    return EffortService().createEffort(widget.taskId, data);
  }

  bool areChangesMade() {
    return checkEmpty() && checkChanges();
  }

  bool checkChanges() {
    for (int i = 0; i < employees.length; i++) {
      if (_minutesController[i].text !=
          employees[i]['totalActualEfforMinutes'].toString()) {
        return true;
      }
    }
    for (int i = 0; i < employees.length; i++) {
      if (_hoursController[i].text !=
          employees[i]['totalActualEffortHour'].toString()) {
        return true;
      }
    }

    for (int i = 0; i < employees.length; i++) {
      if (employees[i]['daySubmit'] == null) {
        employees[i]['daySubmit'] = "";
      }
      String date = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(employees[i]['daySubmit']));
      if (_selectedDate[i] != date) return true;
    }
    return false;
  }

  bool checkEmpty() {
    for (int i = 0; i < employees.length; i++) {
      if (_hoursController[i].text.isEmpty &&
          _minutesController[i].text.isEmpty) {
        return false;
      }
      if (_selectedDate[i].isEmpty) {
        return false;
      }
    }

    return true;
  }

  List<Map<String, dynamic>> getUpdatedEffortData() {
    List<Map<String, dynamic>> updatedData = [];
    for (int i = 0; i < employees.length; i++) {
      int employeeId = employees[i]['employeeId'];
      if (_minutesController[i].text.isEmpty) _minutesController[i].text = "0";
      if (_hoursController[i].text.isEmpty) _hoursController[i].text = "0";
      int effortTimeM = int.parse(_minutesController[i].text);
      int effortTimeH = int.parse(_hoursController[i].text);

      Map<String, dynamic> updatedEffort = {
        'employeeId': employeeId,
        'actualEfforMinutes': effortTimeM,
        'actualEffortHour': effortTimeH,
        "daySubmit": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
            .format(DateFormat('dd-MM-yyyy').parse(_selectedDate[i])),
      };

      updatedData.add(updatedEffort);
    }
    return updatedData;
  }

  @override
  void initState() {
    super.initState();
    getEmployees();
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close_sharp, color: kSecondColor)),
              title: Text("Ghi nhận thời gian làm việc",
                  style: TextStyle(color: kPrimaryColor)),
              centerTitle: true,
              actions: role == "Manager"
                  ? null
                  : [
                      GestureDetector(
                        onTap: isSaveEnabled
                            ? () {
                                setState(() {
                                  isLoading = true;
                                });
                                widget.isCreate
                                    ? TaskService()
                                        .endTaskAndTimeKeeping(
                                            widget.taskId,
                                            widget.status,
                                            getUpdatedEffortData())
                                        .then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (value) {
                                          Navigator.of(context).pop("ok");
                                          SnackbarShowNoti.showSnackbar(
                                              "Đã lưu thay đổi!", false);
                                        }
                                      }).catchError((e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        SnackbarShowNoti.showSnackbar(
                                            e.toString(), true);
                                      })
                                    : createEffort(getUpdatedEffortData())
                                        .then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (value) {
                                          Navigator.of(context).pop();
                                          SnackbarShowNoti.showSnackbar(
                                              "Đã lưu thay đổi!", false);
                                        }
                                      }).catchError((e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        SnackbarShowNoti.showSnackbar(
                                            e.toString(), true);
                                      });
                              }
                            : null,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color:
                                isSaveEnabled ? kPrimaryColor : Colors.black26,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Center(
                              child: Text(isHaveSubtask! ? "Xác nhận" : "Lưu")),
                        ),
                      ),
                    ],
            ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "#${widget.codeTask}",
                                style: TextStyle(
                                  fontSize: 23.0, // Kích thước nhỏ hơn
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: kSecondColor,
                                ),
                              ),
                              TextSpan(
                                text: " - " + widget.taskName,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: kSecondColor,
                                ),
                              ),
                            ],
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
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Danh sách các nhân viên:",
                          style: TextStyle(fontSize: 19)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: ListView.builder(
                      itemCount: employees.length + 1, // +1 for header row
                      itemBuilder: (context, index) {
                        // Header row
                        if (index == 0) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IntrinsicWidth(
                                    child: Container(
                                      child: Text(
                                        'Mã NV',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        'Nhân viên',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  IntrinsicWidth(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'Ngày thực hiện',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  IntrinsicWidth(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'Giờ thực tế',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: const Divider(
                                  color: Colors.grey, // Đặt màu xám
                                  height: 1, // Độ dày của dòng gạch
                                  thickness:
                                      1, // Độ dày của dòng gạch (có thể thay đổi)
                                ),
                              ),
                            ],
                          );
                        }

                        // Data rows
                        int dataIndex = index - 1;
                        Map<String, dynamic> employee = employees[dataIndex];
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  width: 65,
                                  child: Flexible(
                                      child: Text(employee['employeeCode'])),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      employee['employeeName'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    role == "Manager"
                                        ? null
                                        : _getDateTimeFromUser(dataIndex)
                                            .then((value) {
                                            isSaveEnabled = areChangesMade();
                                          });
                                  },
                                  child: Container(
                                    width: 110,
                                    child: Text(
                                      _selectedDate[dataIndex].isEmpty
                                          ? "dd/mm/yyy"
                                          : _selectedDate[dataIndex],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: TextField(
                                                    textAlign: TextAlign.right,
                                                    readOnly: role == "Manager",
                                                    controller:
                                                        _hoursController[
                                                            dataIndex],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    decoration: InputDecoration(
                                                      hintText: "0",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isSaveEnabled =
                                                            areChangesMade();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                "G",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: TextField(
                                                    textAlign: TextAlign.right,
                                                    readOnly: role == "Manager",
                                                    controller:
                                                        _minutesController[
                                                            dataIndex],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    decoration: InputDecoration(
                                                      hintText: "0",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isSaveEnabled =
                                                            areChangesMade();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                "p",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _getDateTimeFromUser(index) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate[index] = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
      return;
    }
    return;
  }
}
