import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/employee.dart';
import 'package:manager_somo_farm_task_management/models/employee_task_type.dart';
import 'package:manager_somo_farm_task_management/models/material.dart';
import 'package:manager_somo_farm_task_management/models/task_type.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/third_add_task_page.dart';

class SecondAddTaskPage extends StatefulWidget {
  const SecondAddTaskPage({super.key});

  @override
  State<SecondAddTaskPage> createState() => _SecondAddTaskPage();
}

class _SecondAddTaskPage extends State<SecondAddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedTaskType = listTaskTypes[0].taskTypeName;
  Key _keyChange = UniqueKey();
  List<Employee> filteredEmployees = listEmployeeTaskTypes
      .where((employeeTaskType) => employeeTaskType.taskTypeId == 1)
      .map((employeeTaskType) => listEmployees.firstWhere(
          (employee) => employee.employeeId == employeeTaskType.employeeId))
      .toList();
  List<String> user = ["Ronaldo", "Messi", "Benzema", "Mac Hai"];
  String _selectedUser = "Ronaldo";

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
                title: "Loại nhiệm vụ",
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
                      _keyChange =
                          UniqueKey(); // Đặt lại người thực hiện khi thay đổi loại nhiệm vụ
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
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Người thực hiện", // Thay đổi tiêu đề nếu cần thiết
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
                          key: _keyChange,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Chọn người thực hiện",
                              hintStyle: TextStyle(color: Colors.black45)),
                          initialValue: [],
                          findSuggestions: (String query) {
                            if (query.length != 0) {
                              var lowercaseQuery = query.toLowerCase();
                              return filteredEmployees.where((e) {
                                return e.fullName
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              }).toList(growable: false)
                                ..sort((a, b) => a.fullName
                                    .toLowerCase()
                                    .indexOf(lowercaseQuery)
                                    .compareTo(b.fullName
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)));
                            } else {
                              return const <Employee>[];
                            }
                          },
                          onChanged: (data) {
                            print(data);
                          },
                          chipBuilder: (context, state, employee) {
                            return InputChip(
                              key: ObjectKey(employee),
                              label: Text(employee.fullName),
                              onDeleted: () => state.deleteChip(employee),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder: (context, state, profile) {
                            return ListTile(
                              key: ObjectKey(profile),
                              title: Text(profile.fullName),
                              onTap: () => state.selectSuggestion(profile),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MyInputField(
                title: "Người giám sát",
                hint: _selectedUser,
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
                              var lowercaseQuery = query.toLowerCase();
                              return materials.where((m) {
                                return m.materialName
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              }).toList(growable: false)
                                ..sort((a, b) => a.materialName
                                    .toLowerCase()
                                    .indexOf(lowercaseQuery)
                                    .compareTo(b.materialName
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)));
                            } else {
                              return const <Employee>[];
                            }
                          },
                          onChanged: (data) {
                            print(data);
                          },
                          chipBuilder: (context, state, material) {
                            return InputChip(
                              key: ObjectKey(material),
                              label: Text(material.materialName),
                              onDeleted: () => state.deleteChip(material),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder: (context, state, profile) {
                            return ListTile(
                              key: ObjectKey(profile),
                              title: Text(profile.materialName),
                              onTap: () => state.selectSuggestion(profile),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MyInputField(
                title: "Mô tả",
                hint: "Nhập mô tả",
                controller: _noteController,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ThirdAddTaskPage(),
                        ),
                      );
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
}
