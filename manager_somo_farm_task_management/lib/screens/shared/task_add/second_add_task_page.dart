import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/third_add_task_page.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/material_service.dart';
import 'package:manager_somo_farm_task_management/services/member_service.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondAddTaskPage extends StatefulWidget {
  final bool isPlant;
  final int fieldId;
  final int? plantId;
  final int? otherId;
  final int? liveStockId;
  SecondAddTaskPage(
      {super.key,
      required this.isPlant,
      required this.fieldId,
      this.otherId,
      this.liveStockId,
      this.plantId});

  @override
  State<SecondAddTaskPage> createState() => _SecondAddTaskPage();
}

class _SecondAddTaskPage extends State<SecondAddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  String _selectedTaskType = "";
  int? _selectedTaskTypeId;
  Key _keyChange = UniqueKey();
  List<Map<String, dynamic>> filteredEmployees = [];
  List<Map<String, dynamic>> selectedEmployees = [];
  String hintEmployee = "";
  List<Map<String, dynamic>> selectedMaterials = [];
  List<Map<String, dynamic>> materials = [];
  List<Map<String, dynamic>> supervisors = [];
  String _selectedSupervisor = "Chọn";
  int? _selectedSupervisorId;
  List<Map<String, dynamic>> taskTypes = [];
  int farmId = -1;
  String? role;
  int? userId;
  Future<List<Map<String, dynamic>>> getListTaskTypeLivestocks() {
    return TaskTypeService().getListTaskTypeLivestock();
  }

  Future<List<Map<String, dynamic>>> getListTaskTypePlants() {
    return TaskTypeService().getTaskTypePlants();
  }

  Future<List<Map<String, dynamic>>> getEmployeesbyFarmIdAndTaskTypeId(
      int farmId, int taskTypeId) {
    return EmployeeService()
        .getEmployeesbyFarmIdAndTaskTypeId(farmId, taskTypeId);
  }

  Future<List<Map<String, dynamic>>> getSupervisorsbyFarmId(int farmId) {
    return MemberService().getSupervisorsActivebyFarmId(farmId);
  }

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');

    setState(() {
      userId = storedUserId;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    getRole();
    getFarmId().then((f) {
      setState(() {
        farmId = f!;
      });
      getSupervisorsbyFarmId(f!).then((s) {
        setState(() {
          supervisors = s;
        });
      });
    });
    widget.isPlant
        ? getListTaskTypePlants().then((value) {
            setState(() {
              taskTypes = value;
            });
          })
        : getListTaskTypeLivestocks().then((value) {
            setState(() {
              taskTypes = value;
            });
          });
    _selectedTaskType = "Chọn";
    MaterialService().getMaterialActive().then((value) {
      setState(() {
        materials = value;
      });
    });
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm công việc (2/3)",
                style: headingStyle,
              ),
              MyInputField(
                title: "Tên công việc",
                hint: "Nhập tên công việc",
                controller: _titleController,
              ),
              MyInputField(
                title: "Loại công việc",
                hint: _selectedTaskType,
                widget: DropdownButton(
                  underline: Container(height: 0),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (Map<String, dynamic>? newValue) {
                    setState(() {
                      _selectedTaskType = newValue!['name'];
                      _selectedTaskTypeId = newValue['id'];
                      selectedEmployees.clear();
                      // Gọi setState để cập nhật danh sách người thực hiện
                      _keyChange =
                          UniqueKey(); // Đặt lại người thực hiện khi thay đổi loại nhiệm vụ
                    });
                    // Lọc danh sách Employee tương ứng với TaskType đã chọn
                    getEmployeesbyFarmIdAndTaskTypeId(farmId, newValue!['id'])
                        .then((value) {
                      setState(() {
                        filteredEmployees = value;
                        hintEmployee = value.isEmpty
                            ? "Không có người phù hợp với loại công việc"
                            : "Chọn người thực hiện";
                      });
                    });
                  },
                  items: taskTypes.map<DropdownMenuItem<Map<String, dynamic>>>(
                      (Map<String, dynamic> value) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: value,
                      child: Text(value['name']),
                    );
                  }).toList(),
                ),
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
                    Container(
                      height: 52,
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.only(left: 14),
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
                          key: _keyChange,
                          enabled: !hintEmployee.isEmpty,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hintEmployee,
                              hintStyle: TextStyle(color: Colors.black45)),
                          initialValue: [],
                          findSuggestions: (String query) {
                            if (query.length != 0) {
                              var lowercaseQuery =
                                  removeDiacritics(query.toLowerCase());
                              return filteredEmployees.where((e) {
                                return removeDiacritics(e['name'].toLowerCase())
                                    .contains(lowercaseQuery);
                              }).toList(growable: false)
                                ..sort((a, b) =>
                                    removeDiacritics(a['name'].toLowerCase())
                                        .indexOf(lowercaseQuery)
                                        .compareTo(removeDiacritics(
                                                b['name'].toLowerCase())
                                            .indexOf(lowercaseQuery)));
                            } else {
                              return const <Map<String, dynamic>>[];
                            }
                          },
                          onChanged: (data) {
                            selectedEmployees =
                                data.cast<Map<String, dynamic>>();
                            print(selectedEmployees);
                          },
                          chipBuilder: (context, state, employee) {
                            return InputChip(
                              key: ObjectKey(employee),
                              label: Text(employee['name']),
                              onDeleted: () => state.deleteChip(employee),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder: (context, state, profile) {
                            return ListTile(
                              key: ObjectKey(profile),
                              title: Text(profile['name']),
                              onTap: () => state.selectSuggestion(profile),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (hintEmployee == "Không có người phù hợp với loại công việc")
                Text(
                  "Hãy chọn loại công việc khác",
                  style: TextStyle(fontSize: 11, color: Colors.red, height: 2),
                ),
              role == "Manager"
                  ? MyInputField(
                      title: "Người giám sát",
                      hint: _selectedSupervisor,
                      widget: DropdownButton(
                        underline: Container(height: 0),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: subTitileStyle,
                        onChanged: (Map<String, dynamic>? newValue) {
                          setState(() {
                            _selectedSupervisor = newValue!['name'];
                            _selectedSupervisorId = newValue['id'];
                          });
                        },
                        items: supervisors
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dụng cụ", // Thay đổi tiêu đề nếu cần thiết
                      style:
                          titileStyle, // Đảm bảo bạn đã định nghĩa titileStyle
                    ),
                    Container(
                      height: 52,
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.only(left: 14),
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
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Chọn dụng cụ cần thiết",
                              hintStyle: TextStyle(color: Colors.black45)),
                          initialValue: [],
                          findSuggestions: (String query) {
                            if (query.length != 0) {
                              var lowercaseQuery =
                                  removeDiacritics(query.toLowerCase());
                              return materials.where((m) {
                                return removeDiacritics(m['name'].toLowerCase())
                                    .contains(lowercaseQuery);
                              }).toList(growable: false)
                                ..sort((a, b) =>
                                    removeDiacritics(a['name'].toLowerCase())
                                        .indexOf(lowercaseQuery)
                                        .compareTo(removeDiacritics(
                                                b['name'].toLowerCase())
                                            .indexOf(lowercaseQuery)));
                            } else {
                              return const <Map<String, dynamic>>[];
                            }
                          },
                          onChanged: (data) {
                            selectedMaterials =
                                data.cast<Map<String, dynamic>>();
                            print(data);
                          },
                          chipBuilder: (context, state, material) {
                            return InputChip(
                              key: ObjectKey(material),
                              label: Text(material['name']),
                              onDeleted: () => state.deleteChip(material),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder: (context, state, material) {
                            return ListTile(
                              key: ObjectKey(material),
                              title: Text(material['name']),
                              onTap: () => state.selectSuggestion(material),
                            );
                          },
                        ),
                      ),
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
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  GestureDetector(
                    onTap: () {
                      _validateDate();
                    },
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
                        "Tiếp theo",
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
    if (_titleController.text.isEmpty ||
        selectedEmployees.isEmpty ||
        _selectedTaskTypeId == null) {
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
      return;
    }

    if (role == "Manager" && _selectedSupervisorId == null) {
      SnackbarShowNoti.showSnackbar('Vui lòng chọn giám sát viên', true);
      return;
    }
    //add database
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ThirdAddTaskPage(
          fiedlId: widget.fieldId,
          otherId: widget.otherId,
          plantId: widget.plantId,
          liveStockId: widget.liveStockId,
          taskName: _titleController.text,
          taskTypeId: _selectedTaskTypeId!,
          employeeIds: selectedEmployees
              .map<int>((employee) => employee['id'] as int)
              .toList(),
          supervisorId: role == "Manager" ? _selectedSupervisorId! : userId!,
          materialIds:
              selectedMaterials.map<int>((m) => m['id'] as int).toList(),
          description: _desController.text,
          role: role!,
        ),
      ),
    );
  }
}
