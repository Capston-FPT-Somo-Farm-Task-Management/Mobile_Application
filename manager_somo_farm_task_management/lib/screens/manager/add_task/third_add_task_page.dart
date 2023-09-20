import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/componets/input_field.dart';

class ThirdAddTaskPage extends StatefulWidget {
  const ThirdAddTaskPage({super.key});

  @override
  State<ThirdAddTaskPage> createState() => _ThirdAddTaskPage();
}

class _ThirdAddTaskPage extends State<ThirdAddTaskPage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  DateTime? _selectedDateRepeatUntil;
  String _endTime = "hh:mm a";
  String _startTime = "hh:mm a";
  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = "Không";
  List<String> repeatList = ["Không", "Hàng ngày", "Hàng tuần", "Hàng tháng"];
  String showInputFieldRepeat = "Không";
  List<int> repeatNumbers = [];
  int _selectedRepeatNumber = 1;
  int _selectedColor = 0;
  List<String> priorities = ["Thấp", "Trung Bình", "Cao"];
  String _selectedPriority = "Thấp";
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
                "Thêm công việc (3/3)",
                style: headingStyle,
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
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  underline: Container(height: 0),
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
                  underline: Container(height: 0),
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
                      showInputFieldRepeat = newValue;
                      if (showInputFieldRepeat != "Không") {
                        for (int i = 1; i <= 30; i++) {
                          repeatNumbers.add(i);
                        }
                      }
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
              if (showInputFieldRepeat != "Không")
                MyInputField(
                  title: "Lặp mỗi",
                  hint: "$_selectedRepeatNumber",
                  widget: DropdownButton(
                    underline: Container(height: 0),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitileStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeatNumber = int.parse(newValue!);
                      });
                    },
                    items: repeatNumbers
                        .map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    menuMaxHeight: 200,
                  ),
                ),
              if (showInputFieldRepeat != "Không")
                Container(
                  margin: const EdgeInsets.only(top: 7.0),
                  child: Text(
                    showInputFieldRepeat.split(' ').last,
                    style: titileStyle,
                  ),
                ),
              if (showInputFieldRepeat != "Không")
                MyInputField(
                  title: "Lặp đến ngày",
                  hint: _selectedDateRepeatUntil == null
                      ? "dd/MM/yyy"
                      : DateFormat('dd/MM/yyyy')
                          .format(_selectedDateRepeatUntil!),
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
              MyInputField(
                title: "Độ ưu tiên",
                hint: _selectedPriority,
                widget: DropdownButton(
                  underline: Container(height: 0),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items:
                      priorities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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
    if (_selectedStartDate != null &&
        _selectedEndDate != null &&
        _startTime != "hh:mm a" &&
        _endTime != "hh:mm a" &&
        _selectedRepeat == "Không") {
      //add database
      Navigator.of(context).pop();
    } else if (_selectedRepeat != "Không" && _selectedDateRepeatUntil != null) {
      Navigator.of(context).pop();
    } else {
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      SnackbarShowNoti.showSnackbar(
          context, 'Vui lòng điền đầy đủ thông tin', true);
    }
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 36525)),
    );
    if (_pickerDate == null) {
      print("it's null or something is wrong");
      return;
    }
    if (_selectedStartDate == null) {
      SnackbarShowNoti.showSnackbar(context, "Chọn ngày thực hiện trước", true);
    } else if (_pickerDate.isBefore(_selectedStartDate!)) {
      SnackbarShowNoti.showSnackbar(
          context, "Ngày kết thúc lặp lại phải lớn hơn ngày thực hiện", true);
    } else {
      setState(() {
        _selectedDateRepeatUntil = _pickerDate;
      });
    }
  }

  _getDateTimeFromUser(bool isStart) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 36525)),
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

        if (isStart == false && _selectedStartDate == null) {
          SnackbarShowNoti.showSnackbar(
              context, "Chọn ngày giờ thực hiện trước", true);
        } else if (isStart == false &&
            selectedDateTime.isBefore(_selectedStartDate!)) {
          SnackbarShowNoti.showSnackbar(context,
              "Ngày giờ kết thúc phải lớn hơn ngày giờ thực hiện", true);
        } else {
          setState(() {
            if (isStart) {
              _selectedStartDate = selectedDateTime;
              _selectedEndDate = null;
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

  _getTimeFromUser({required bool isStartTime}) async {
    var pickerTime = await _showTimePicker();

    if (pickerTime == null) {
      print('Time canceled');
      return;
    }

    String _formattedTime = pickerTime.format(context);

    if (isStartTime) {
      setState(() {
        _startTime = _formattedTime;
        _endTime = "hh:mm a";
      });
    } else if (_startTime == "hh:mm a") {
      SnackbarShowNoti.showSnackbar(context, "Chọn giờ bắt đầu trước", true);
    } else {
      DateTime startTime = DateFormat('hh:mm a').parse(_startTime);
      DateTime endTime = DateFormat('hh:mm a').parse(_formattedTime);

      if (endTime.isAfter(startTime)) {
        setState(() {
          _endTime = _formattedTime;
        });
      } else {
        SnackbarShowNoti.showSnackbar(
            context, "Giờ kết thúc phải lớn hơn giờ bắt đầu", true);
      }
    }
  }

  _showTimePicker() {
    String time = DateFormat("hh:mm a").format(DateTime.now()).toString();
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
