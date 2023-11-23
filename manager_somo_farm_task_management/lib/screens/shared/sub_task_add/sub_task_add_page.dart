import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/sub_task_service.dart';

import '../../../componets/input_field.dart';

class CreateSubTask extends StatefulWidget {
  final int taskId;
  final String taskName;
  final String startDate;
  final String taskCode;
  const CreateSubTask(
      {super.key,
      required this.taskId,
      required this.taskName,
      required this.startDate,
      required this.taskCode});

  @override
  CreateSubTaskState createState() => CreateSubTaskState();
}

class CreateSubTaskState extends State<CreateSubTask> {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  List<Map<String, dynamic>> employees = [];
  Map<String, dynamic>? employeeSelected;
  bool isLoading = true;
  DateTime? _selectedDate;
  Future<bool> createSubTask(Map<String, dynamic> subTaskData) {
    return SubTaskService().createSubTask(subTaskData);
  }

  void getEmployees() async {
    EmployeeService().getEmployeesbyTaskId(widget.taskId).then((value) {
      setState(() {
        employees = value;
        isLoading = false;
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#" + widget.taskCode + " - " + widget.taskName,
                      style: headingStyle.copyWith(fontSize: 23),
                    ),
                    SizedBox(height: 30),
                    MyInputField(
                      title: "Tên công việc con",
                      hint: "Nhập tên công việc con",
                      controller: _titleController,
                      hintColor: Colors.grey,
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
                              value: employeeSelected,
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
                                  child: Text(value['nameCode']),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    MyInputField(
                      title: "Ngày thực hiện",
                      hint: _selectedDate == null
                          ? "dd/MM/yyyy"
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDateTimeFromUser();
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Thời gian làm việc thực tế",
                            style: titileStyle,
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: TextField(
                                            textAlign: TextAlign.right,
                                            controller: _hoursController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("Giờ")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: TextField(
                                            textAlign: TextAlign.right,
                                            controller: _minutesController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            onChanged: (value) {
                                              // Kiểm tra giá trị sau khi người dùng nhập
                                              if (value.isNotEmpty) {
                                                int numericValue =
                                                    int.parse(value);
                                                if (numericValue > 59) {
                                                  _minutesController.text =
                                                      "59";
                                                }
                                              }
                                            },
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("Phút")
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                            "Mô tả (Tùy chọn)",
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
                                hintStyle: subTitileStyle.copyWith(
                                    color: kTextGreyColor),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackgroundColor, width: 0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackgroundColor, width: 0),
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
    if (_titleController.text.isNotEmpty &&
        employeeSelected != null &&
        _selectedDate != null) {
      Map<String, dynamic> data = {
        'taskId': widget.taskId,
        'employeeId': employeeSelected!['id'],
        'description': _desController.text,
        'daySubmit':
            DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedDate!),
        'name': _titleController.text,
        "overallEfforMinutes":
            _minutesController.text.isEmpty ? 0 : _minutesController.text,
        "overallEffortHour":
            _hoursController.text.isEmpty ? 0 : _hoursController.text,
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

  _getDateTimeFromUser() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
      return;
    }
    return;
  }
}
