import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/employee.dart';
import 'package:manager_somo_farm_task_management/models/employee_task_type.dart';
import 'package:manager_somo_farm_task_management/models/task.dart';
import 'package:manager_somo_farm_task_management/models/task_type.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/componets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "Không";
  List<String> repeatList = ["Không", "Hàng ngày", "Hàng tuần", "Hàng tháng"];
  List<String> field = ["Khu CN1", "Khu CN2", "Khu CN3", "Khu TT1"];
  String _selectedField = "Khu CN1";
  List<String> taskType = ["Trồng trọt", "Chăn nuôi", "Thú y", "Đất đai"];
  String _selectedTaskType = listTaskTypes[0].taskTypeName;
  String _selectedEmployee = listEmployees[0].fullName;
  List<Employee> filteredEmployees = listEmployeeTaskTypes
      .where((employeeTaskType) => employeeTaskType.taskTypeId == 1)
      .map((employeeTaskType) => listEmployees.firstWhere(
          (employee) => employee.employeeId == employeeTaskType.employeeId))
      .toList();
  List<String> user = ["Ronaldo", "Messi", "Benzema", "Mac Hai"];
  String _selectedUser = "Ronaldo";

  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
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
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm công việc",
                style: headingStyle,
              ),
              MyInputField(
                title: "Tên công việc",
                hint: "Nhập tên công việc",
                controller: _titleController,
              ),
              MyInputField(
                title: "Loại nhiệm vụ",
                hint: _selectedTaskType,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (TaskType? newValue) {
                    setState(() {
                      _selectedTaskType = newValue!.taskTypeName;

                      // Lọc danh sách Employee tương ứng với TaskType đã chọn
                      filteredEmployees = listEmployeeTaskTypes
                          .where((employeeTaskType) =>
                              employeeTaskType.taskTypeId ==
                              newValue.taskTypeId)
                          .map((employeeTaskType) => listEmployees.firstWhere(
                              (employee) =>
                                  employee.employeeId ==
                                  employeeTaskType.employeeId))
                          .toList();

                      // Gọi setState để cập nhật danh sách người thực hiện
                      _selectedEmployee = filteredEmployees[0]
                          .fullName; // Đặt lại người thực hiện khi thay đổi loại nhiệm vụ
                    });
                  },
                  items: listTaskTypes
                      .map<DropdownMenuItem<TaskType>>((TaskType value) {
                    return DropdownMenuItem<TaskType>(
                      value: value,
                      child: Text(value.taskTypeName),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Người thực hiện",
                hint: _selectedEmployee,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (Employee? newValue) {
                    setState(() {
                      _selectedUser = newValue!.fullName;
                    });
                  },
                  items: filteredEmployees
                      .map<DropdownMenuItem<Employee>>((Employee value) {
                    return DropdownMenuItem<Employee>(
                      value: value,
                      child: Text(value.fullName),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Người giám sát",
                hint: _selectedUser,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUser = newValue!;
                    });
                  },
                  items: user.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Mô tả",
                hint: "Nhập mô tả",
                controller: _noteController,
              ),
              MyInputField(
                title: "Ngày thực hiện",
                hint: DateFormat('dd/MM/yyyy').format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Giờ bắt đầu",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "Giờ kết thúc",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Khu đất",
                hint: _selectedField,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedField = newValue!;
                    });
                  },
                  items: field.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Lặp lại",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color",
                        style: titileStyle,
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        children: List<Widget>.generate(3, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: index == 0
                                    ? kPrimaryColor
                                    : index == 1
                                        ? kSecondColor
                                        : kTextBlueColor,
                                child: _selectedColor == index
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _validateDate(),
                    child: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kPrimaryColor,
                      ),
                      alignment: Alignment
                          .center, // Đặt alignment thành Alignment.center
                      child: const Text(
                        "Create Task",
                        style: TextStyle(
                          color: kTextWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add database
      Navigator.of(context).pop();
    } else {
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      const snackBar = SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red, // Màu của biểu tượng cảnh báo
            ),
            SizedBox(width: 8), // Khoảng cách giữa biểu tượng và nội dung
            Text(
              'Vui lòng điền đầy đủ thông tin',
              style: TextStyle(
                color: Colors.red, // Màu của nội dung
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // Màu nền của Snackbar
      );

      // Hiển thị Snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 36525)),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickerTime = await _showTimePicker();
    String _formatedTime = pickerTime.format(context);
    if (pickerTime == null) {
      print('Time canceld');
    } else if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
