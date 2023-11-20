import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/priority.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssignTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;

  const AssignTaskPage({super.key, required this.task});
  @override
  State<AssignTaskPage> createState() => _AssignTaskPage();
}

class _AssignTaskPage extends State<AssignTaskPage> {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> selectedEmployees = [];
  bool isLoading = true;
  int? farmId;
  Future<List<Map<String, dynamic>>> getEmployeesbyFarmIdAndTaskTypeId(
      int taskTypeId) {
    return EmployeeService()
        .getEmployeesbyFarmIdAndTaskTypeId(farmId!, taskTypeId);
  }

  Future<void> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    setState(() {
      farmId = storedFarmId!;
    });
  }

  @override
  void initState() {
    super.initState();
    getFarmId().then((_) {
      getEmployeesbyFarmIdAndTaskTypeId(widget.task['taskTypeId'])
          .then((value) {
        setState(() {
          employees = value;
          selectedEmployees = employees
              .where((element) =>
                  widget.task['employeeId'].contains(element['id']))
              .toList();
          isLoading = false;
        });
      });
    });
    _minutesController.text = widget.task['overallEfforMinutes'].toString();
    _hoursController.text = widget.task['overallEffortHour'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(
          "Giao công việc",
          style: headingStyle.copyWith(fontSize: 25),
        ),
        centerTitle: true,
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
          top: 10,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Skeletonizer(
            enabled: isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '#${widget.task['code']}',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic, // Chữ in nghiêng
                      color: Priority.getBGClr(widget.task['priority']),
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Người thực hiện",
                        style: titileStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        constraints: BoxConstraints(minHeight: 52),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SingleChildScrollView(
                          child: ChipsInput(
                            suggestionsBoxMaxHeight: 200,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Chọn",
                                hintStyle: TextStyle(color: Colors.black45)),
                            initialValue: selectedEmployees,
                            findSuggestions: (String query) {
                              if (query.length != 0) {
                                var lowercaseQuery =
                                    removeDiacritics(query.toLowerCase());
                                return employees.where((e) {
                                  return removeDiacritics(
                                          e['nameCode'].toLowerCase())
                                      .contains(lowercaseQuery);
                                }).toList(growable: false)
                                  ..sort((a, b) => removeDiacritics(
                                          a['nameCode'].toLowerCase())
                                      .indexOf(lowercaseQuery)
                                      .compareTo(removeDiacritics(
                                              b['nameCode'].toLowerCase())
                                          .indexOf(lowercaseQuery)));
                              } else {
                                return const <Map<String, dynamic>>[];
                              }
                            },
                            onChanged: (data) {
                              selectedEmployees =
                                  data.cast<Map<String, dynamic>>();
                            },
                            chipBuilder: (context, state, employee) {
                              return InputChip(
                                key: ObjectKey(employee),
                                label: Text(employee['nameCode']),
                                onDeleted: () => state.deleteChip(employee),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              );
                            },
                            suggestionBuilder: (context, state, profile) {
                              return ListTile(
                                key: ObjectKey(profile),
                                title: Text(profile['nameCode']),
                                onTap: () => state.selectSuggestion(profile),
                              );
                            },
                          ),
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
                                              keyboardType:
                                                  TextInputType.number,
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
                                              keyboardType:
                                                  TextInputType.number,
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        validate(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kPrimaryColor,
                        ),
                        alignment: Alignment
                            .center, // Đặt alignment thành Alignment.center
                        child: const Text(
                          "Giao việc",
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
      ),
    );
  }

  validate(context) {
    setState(() {
      isLoading = true;
    });
    if (selectedEmployees.isEmpty ||
        (_hoursController.text.isEmpty && _minutesController.text.isEmpty)) {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar("Điền đầy đủ thông tin để giao việc", true);
    } else {
      Map<String, dynamic> data = {
        "employeeIds": selectedEmployees
            .map<int>((employee) => employee['id'] as int)
            .toList(),
        "overallEfforMinutes": _minutesController.text.trim().isEmpty
            ? 0
            : _minutesController.text.trim(),
        "overallEffortHour": _hoursController.text.trim().isEmpty
            ? 0
            : _hoursController.text.trim(),
      };
      TaskService()
          .addEmployeeToTaskAsign(data, widget.task['id'])
          .then((value) {
        if (value) {
          Navigator.of(context).pop("ok");
          SnackbarShowNoti.showSnackbar('Giao công việc thành công', false);
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    }
  }
}
