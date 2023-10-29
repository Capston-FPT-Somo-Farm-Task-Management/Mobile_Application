import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/effort_service.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';

class TimeKeepingInTask extends StatefulWidget {
  final int taskId;
  final String taskName;
  final bool isCreate;
  final int status;
  TimeKeepingInTask(
      {required this.taskId,
      required this.taskName,
      required this.isCreate,
      required this.status});

  @override
  State<TimeKeepingInTask> createState() => _TimeKeepingInTaskState();
}

class _TimeKeepingInTaskState extends State<TimeKeepingInTask> {
  bool isLoading = true;
  List<Map<String, dynamic>> employees = [];
  List<TextEditingController> controllers = [];
  bool isSaveEnabled = false;
  void getEmployees() {
    EffortService().getEffortByTaskId(widget.taskId).then((value) {
      setState(() {
        employees = value;
        for (int i = 0; i < employees.length; i++) {
          TextEditingController controller = TextEditingController(
              text: employees[i]['effortTime'].toString());
          controllers.add(controller);
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
      if (controllers[i].text != employees[i]['effortTime'].toString()) {
        return true;
      }
    }
    return false;
  }

  bool checkEmpty() {
    for (int i = 0; i < employees.length; i++) {
      if (controllers[i].text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  List<Map<String, dynamic>> getUpdatedEffortData() {
    List<Map<String, dynamic>> updatedData = [];
    for (int i = 0; i < employees.length; i++) {
      int employeeId = employees[i]['employeeId'];
      double effortTime = double.parse(controllers[i].text);

      Map<String, dynamic> updatedEffort = {
        'employeeId': employeeId,
        'effortTime': effortTime,
      };

      updatedData.add(updatedEffort);
    }
    return updatedData;
  }

  @override
  void initState() {
    super.initState();
    getEmployees();
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
              title: Text("Chấm công", style: TextStyle(color: kPrimaryColor)),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: isSaveEnabled
                      ? () {
                          setState(() {
                            isLoading = true;
                          });
                          widget.isCreate
                              ? TaskService()
                                  .endTaskAndTimeKeeping(widget.taskId,
                                      widget.status, getUpdatedEffortData())
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
                      color: isSaveEnabled ? kPrimaryColor : Colors.black26,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: Center(child: Text("Lưu")),
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
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.taskName,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: kSecondColor)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mã NV',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text('Nhân viên',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text('Giờ thực tế',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 100,
                                  child: Text(employee['employeeCode'])),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    employee['employeeName'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: TextField(
                                  controller: controllers[dataIndex],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}$')),
                                  ],
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 1.0),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      isSaveEnabled = areChangesMade();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
