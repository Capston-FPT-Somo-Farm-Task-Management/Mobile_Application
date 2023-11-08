import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/sub_task_service.dart';

import '../../../componets/input_field.dart';

class UpdateSubTask extends StatefulWidget {
  final int taskId;
  final String taskName;
  final String taskCode;
  final String startDate, endDate;
  final Map<String, dynamic> subtask;
  const UpdateSubTask(
      {super.key,
      required this.taskId,
      required this.taskName,
      required this.subtask,
      required this.taskCode,
      required this.startDate,
      required this.endDate});

  @override
  UpdateSubTaskState createState() => UpdateSubTaskState();
}

class UpdateSubTaskState extends State<UpdateSubTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  List<Map<String, dynamic>> employees = [];
  Map<String, dynamic>? employeeSelected;
  bool isLoading = true;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  Future<bool> updateSubTask(Map<String, dynamic> subTaskData) {
    return SubTaskService()
        .updateSubTask(widget.subtask['subtaskId'], subTaskData);
  }

  void getEmployees() async {
    EmployeeService().getEmployeesbyTaskId(widget.taskId).then((value) {
      setState(() {
        employees = value;
        employeeSelected = employees
            .where((element) => widget.subtask['employeeId'] == element['id'])
            .firstOrNull;
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
    _titleController.text = widget.subtask['name'];
    _desController.text = widget.subtask['description'];
    _selectedStartDate = DateTime.parse((widget.startDate));

    _selectedEndDate = DateTime.parse(widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chỉnh sửa công việc con",
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
                                  child: Text(value['name']),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    MyInputField(
                      title: "Ngày giờ thực hiện",
                      hint: _selectedStartDate == null
                          ? "dd/MM/yyyy HH:mm a"
                          : DateFormat('dd/MM/yyyy HH:mm a')
                              .format(_selectedStartDate!),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDateTimeFromUser(true);
                        },
                      ),
                    ),
                    MyInputField(
                      title: "Ngày giờ kết thúc",
                      hint: _selectedEndDate == null
                          ? "dd/MM/yyyy HH:mm a"
                          : DateFormat('dd/MM/yyyy HH:mm a')
                              .format(_selectedEndDate!),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getDateTimeFromUser(false);
                        },
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
                            "Chỉnh sửa công việc con",
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
        _selectedEndDate != null &&
        _selectedStartDate != null) {
      Map<String, dynamic> data = {
        'employeeId': employeeSelected!['id'],
        'description': _desController.text,
        'startDay':
            DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedStartDate!),
        'endDay':
            DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedEndDate!),
        'name': _titleController.text,
      };
      print(data);
      updateSubTask(data).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newSubtask");
          SnackbarShowNoti.showSnackbar('Cập nhật công việc thành công', false);
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

  _getDateTimeFromUser(bool isStart) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.startDate),
      firstDate: DateTime.parse(widget.startDate),
      lastDate: DateTime.parse(widget.endDate),
    );

    if (selectedDate != null) {
      // Nếu người dùng đã chọn một ngày, tiếp theo bạn có thể chọn giờ
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Người dùng đã chọn cả ngày và giờ
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        if (selectedDateTime.isAfter(DateTime.parse(widget.endDate)) &&
            isStart == false)
          SnackbarShowNoti.showSnackbar(
              "Giờ kết thúc phải nhỏ hơn giờ kết thúc của công việc cha", true);
        else if (selectedDateTime.isBefore(DateTime.parse(widget.startDate)) &&
            isStart)
          SnackbarShowNoti.showSnackbar(
              "Giờ bắt đầu phải lớn hơn giờ bắt đầu của công việc cha", true);
        else if (isStart == false && _selectedStartDate == null) {
          SnackbarShowNoti.showSnackbar("Chọn ngày giờ thực hiện trước", true);
        } else if (isStart == false &&
                selectedDateTime.isBefore(_selectedStartDate!) ||
            isStart == false &&
                selectedDateTime.isAtSameMomentAs(_selectedStartDate!)) {
          SnackbarShowNoti.showSnackbar(
              "Ngày giờ kết thúc phải lớn hơn ngày giờ thực hiện", true);
        } else {
          setState(() {
            if (isStart) {
              _selectedStartDate = selectedDateTime;
              if (_selectedEndDate != null) {
                if (_selectedStartDate!.isAfter(_selectedEndDate!))
                  _selectedEndDate = null;
              }
            } else {
              _selectedEndDate = selectedDateTime;
            }
          });
        }
      }
      return;
    }
    return;
  }
}
