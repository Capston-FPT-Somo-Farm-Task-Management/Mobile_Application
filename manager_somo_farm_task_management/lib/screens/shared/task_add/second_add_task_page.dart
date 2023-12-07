import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/third_add_task_page.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/material_service.dart';
import 'package:manager_somo_farm_task_management/services/member_service.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondAddTaskPage extends StatefulWidget {
  final String? addressDetail;
  final bool? isPlant;
  final int? fieldId;
  final int? plantId;
  final int? liveStockId;
  final bool isOne;
  SecondAddTaskPage(
      {super.key,
      this.isPlant,
      required this.fieldId,
      this.liveStockId,
      this.plantId,
      this.addressDetail,
      required this.isOne});

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

  Future<List<Map<String, dynamic>>> getTaskTypeOther() {
    return TaskTypeService().getTaskTypeOther();
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
      MaterialService().getMaterialActiveByFamrId(farmId).then((value) {
        setState(() {
          materials = value;
        });
      });
    });
    widget.isPlant == null
        ? getTaskTypeOther().then((value) {
            setState(() {
              taskTypes = value;
            });
          })
        : widget.isPlant == true
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
                hintColor: kTextGreyColor,
                controller: _titleController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loại công việc",
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
                          child: DropdownButton2<Map<String, dynamic>>(
                            dropdownStyleData: DropdownStyleData(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4),
                            isExpanded: true,
                            underline: Container(height: 0),
                            // value: _selectedArea,
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                _selectedTaskType = newValue!['name'];
                                _selectedTaskTypeId = newValue['id'];
                                selectedEmployees = [];
                                // Gọi setState để cập nhật danh sách người thực hiện
                                _keyChange =
                                    UniqueKey(); // Đặt lại người thực hiện khi thay đổi loại nhiệm vụ
                              });
                              // Lọc danh sách Employee tương ứng với TaskType đã chọn
                              getEmployeesbyFarmIdAndTaskTypeId(
                                      farmId, newValue!['id'])
                                  .then((value) {
                                setState(() {
                                  filteredEmployees = value;
                                  hintEmployee = value.isEmpty
                                      ? "Không có người phù hợp với loại công việc"
                                      : "Chọn người thực hiện";
                                });
                              });
                            },
                            items: taskTypes
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (Map<String, dynamic> value) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: value,
                                child: Text(value['name']),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                            top: 17, left: 16, child: Text(_selectedTaskType))
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
                      "Người thực hiện",
                      style: titileStyle,
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 52),
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: MultiSelectDropDown<int>(
                          borderColor: Colors.transparent,
                          hint: "Chọn người thực hiện",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          showClearIcon: false,
                          selectedOptions: selectedEmployees.map((employee) {
                            return ValueItem<int>(
                              label: employee['nameCode'],
                              value: employee['id'],
                            );
                          }).toList(),
                          onOptionSelected:
                              (List<ValueItem<int>> selectedOptions) {
                            // Handle selected options
                            selectedEmployees = selectedOptions.map((item) {
                              return {
                                'nameCode': item.label,
                                'id': item.value,
                              };
                            }).toList();
                          },
                          options: filteredEmployees.map((employee) {
                            return ValueItem<int>(
                              label: employee['nameCode'],
                              value: employee['id'],
                            );
                          }).toList(),
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                          dropdownHeight: 200,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionIcon: const Icon(Icons.check_circle),
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
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Người giám sát",
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
                                child: DropdownButton2<Map<String, dynamic>>(
                                  dropdownStyleData: DropdownStyleData(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.4),
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedSupervisor = newValue!['name'];
                                      _selectedSupervisorId = newValue['id'];
                                    });
                                  },
                                  items: supervisors.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: value,
                                      child: Text(value['name']),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  top: 17,
                                  left: 16,
                                  child: Text(_selectedSupervisor))
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dụng cụ (tùy chọn)", // Thay đổi tiêu đề nếu cần thiết
                      style:
                          titileStyle, // Đảm bảo bạn đã định nghĩa titileStyle
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 52),
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: MultiSelectDropDown<int>(
                          borderColor: Colors.transparent,
                          hint: "Chọn dụng cụ",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          showClearIcon: false,
                          selectedOptions: selectedMaterials.map((material) {
                            return ValueItem<int>(
                              label: material['name'],
                              value: material['id'],
                            );
                          }).toList(),
                          onOptionSelected:
                              (List<ValueItem<int>> selectedOptions) {
                            // Handle selected options
                            selectedMaterials = selectedOptions.map((item) {
                              return {
                                'name': item.label,
                                'id': item.value,
                              };
                            }).toList();
                          },
                          options: materials.map((material) {
                            return ValueItem<int>(
                              label: material['name'],
                              value: material['id'],
                            );
                          }).toList(),
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                          dropdownHeight: 200,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionIcon: const Icon(Icons.check_circle),
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
                      "Mô tả (tùy chọn)",
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
                          hintStyle:
                              subTitileStyle.copyWith(color: kTextGreyColor),
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
          addressDetail: widget.addressDetail,
          fiedlId: widget.fieldId,
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
          isOne: widget.isOne,
          isPlant: widget.isPlant,
        ),
      ),
    );
  }
}
