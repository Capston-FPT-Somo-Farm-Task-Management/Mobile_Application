import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/sub_task_service.dart';

import '../../../componets/input_field.dart';

class CreateSubTask extends StatefulWidget {
  final int taskId;
  final String taskName;
  const CreateSubTask(
      {super.key, required this.taskId, required this.taskName});

  @override
  CreateSubTaskState createState() => CreateSubTaskState();
}

class CreateSubTaskState extends State<CreateSubTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  List<Map<String, dynamic>> employees = [];
  Map<String, dynamic>? employeeSelected;
  bool isLoading = false;
  Future<bool> createSubTask(Map<String, dynamic> subTaskData) {
    return SubTaskService().createSubTask(subTaskData);
  }

  void getEmployees() async {
    EmployeeService().getEmployeesbyTaskId(widget.taskId).then((value) {
      setState(() {
        employees = value;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tạo công việc con",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: kBackgroundColor,
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
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.taskName,
                style: headingStyle.copyWith(fontSize: 23),
              ),
              SizedBox(height: 30),
              MyInputField(
                title: "Tên công việc con",
                hint: "Nhập tên công việc con",
                controller: _titleController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Người thực hiện",
                      style: titileStyle,
                    ),
                    SizedBox(height: 5),
                    Container(
                      constraints: BoxConstraints(
                        minHeight:
                            50.0, // Đặt giá trị minHeight theo ý muốn của bạn
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton2<Map<String, dynamic>>(
                        isExpanded: true,
                        underline: Container(height: 0),
                        hint: Text("Chọn"),
                        onChanged: (newValue) {
                          setState(() {
                            employeeSelected = newValue;
                          });
                        },
                        items: employees
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mô tả",
                      style: titileStyle,
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        maxLines: null,
                        autofocus: false,
                        controller: _desController,
                        style: subTitileStyle,
                        decoration: InputDecoration(
                          hintText: "Nhập mô tả",
                          hintStyle: subTitileStyle,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kBackgroundColor, width: 0),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kBackgroundColor, width: 0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              const Divider(
                color: Colors.grey, // Đặt màu xám
                height: 1, // Độ dày của dòng gạch
                thickness: 1, // Độ dày của dòng gạch (có thể thay đổi)
              ),
              const SizedBox(height: 30),
              Align(
                child: ElevatedButton(
                  onPressed: () {
                    _validateDate();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: Size(100, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Tạo công việc con",
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    setState(() {
      isLoading = true;
    });
    if (_titleController.text.isNotEmpty && employeeSelected != null) {
      Map<String, dynamic> data = {
        'taskId': widget.taskId,
        'employeeId': employeeSelected!['id'],
        'description': _desController.text,
        'name': _titleController.text,
      };
      createSubTask(data).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newSubtask");
          SnackbarShowNoti.showSnackbar('Tạo công việc thành công', false);
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
    }
  }
}
