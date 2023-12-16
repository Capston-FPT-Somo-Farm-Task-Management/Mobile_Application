import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/task_page.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:manager_somo_farm_task_management/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThirdAddTaskPage extends StatefulWidget {
  final String? addressDetail;
  final int? fiedlId;
  final int? plantId;
  final int? liveStockId;
  final String taskName;
  final int taskTypeId;
  final List<int> employeeIds;
  final int supervisorId;
  final List<int> materialIds;
  final String? description;
  final String role;
  final bool? isPlant;
  final bool isOne;
  ThirdAddTaskPage({
    super.key,
    required this.fiedlId,
    this.plantId,
    this.liveStockId,
    required this.taskName,
    required this.taskTypeId,
    required this.employeeIds,
    required this.supervisorId,
    required this.materialIds,
    this.description,
    required this.role,
    required this.addressDetail,
    this.isPlant,
    required this.isOne,
  });

  @override
  State<ThirdAddTaskPage> createState() => _ThirdAddTaskPage();
}

class _ThirdAddTaskPage extends State<ThirdAddTaskPage> {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<String> priorities = [
    "Thấp",
    "Trung bình",
    "Cao",
  ];
  String _selectedPriority = "Thấp";
  int? farmId;
  int? userId;
  bool isLoading = false;
  int? rangeDate;
  getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');

    setState(() {
      farmId = storedFarmId;
    });
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');

    setState(() {
      userId = storedUserId;
    });
  }

  Future<bool> createTask(Map<String, dynamic> taskData) {
    return TaskService().superCreateTask(taskData);
  }

  @override
  void initState() {
    super.initState();
    getFarmId();
    getUserId();
  }

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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : SingleChildScrollView(
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
                          ? "Chọn ngày giờ thực hiện"
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
                          ? "Chọn ngày giờ kết thúc"
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
                            "Độ ưu tiên",
                            style: titileStyle,
                          ),
                          SizedBox(height: 5),
                          Stack(
                            children: [
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
                                child: DropdownButton2(
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedPriority = newValue!;
                                    });
                                  },
                                  items: priorities
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  top: 17,
                                  left: 16,
                                  child: Text(_selectedPriority))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Thời gian làm việc dự kiến phải bỏ ra",
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
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                              "Tạo việc",
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
    setState(() {
      isLoading = true;
    });
    if (_selectedStartDate != null &&
        _selectedEndDate != null &&
        (_hoursController.text.isNotEmpty ||
            _minutesController.text.isNotEmpty)) {
      Map<String, dynamic> taskData = {
        "employeeIds": widget.employeeIds,
        "materialIds": widget.materialIds,
        // "dates":
        "taskModel": {
          "name": widget.taskName.trim(),
          "startDate": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
              .format(_selectedStartDate!),
          "endDate":
              DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedEndDate!),
          "description": widget.description,
          "priority": _selectedPriority,
          "suppervisorId":
              widget.role == "Manager" ? widget.supervisorId : userId,
          "fieldId": widget.fiedlId,
          "taskTypeId": widget.taskTypeId,
          "plantId": widget.plantId,
          "liveStockId": widget.liveStockId,
          "addressDetail": widget.addressDetail,
          "overallEfforMinutes": _minutesController.text.trim().isEmpty
              ? 0
              : _minutesController.text.trim(),
          "overallEffortHour": _hoursController.text.trim().isEmpty
              ? 0
              : _hoursController.text.trim(),
          "isPlant": widget.isPlant,
          "isSpecific": widget.isOne
        }
      };

      createTask(taskData).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => BottomNavBar(
                      farmId: farmId!,
                      index: 1,
                      page: TaskPage(),
                    )),
            (route) => false,
          );
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
