import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';

import 'package:manager_somo_farm_task_management/services/provinces_service.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';

import '../../../componets/input_field.dart';

class CreateArea extends StatefulWidget {
  const CreateArea({super.key});

  @override
  CreateAreaState createState() => CreateAreaState();
}

class CreateAreaState extends State<CreateArea> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<Map<String, dynamic>> filteredProvinces = [];
  List<Map<String, dynamic>> filteredDistrict = [];
  List<Map<String, dynamic>> filteredWars = [];
  List<Map<String, dynamic>> filterTaskType = [];
  List<Map<String, dynamic>> selectedTaskTypes = [];
  String? _selectedProvinces = "Chọn";
  String? _selectedDistrict;
  String? _selectedWar;
  bool isLoading = false;
  Future<void> getProvinces() async {
    ProvincesService().getProvinces().then((value) {
      setState(() {
        filteredProvinces = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> getDistrictsByProvinceCode(int code) {
    return ProvincesService().getDistrictsByProvinceCode(code);
  }

  Future<List<Map<String, dynamic>>> getWarsByDistrictCode(int code) {
    return ProvincesService().getWarsByDistrictCode(code);
  }

  Future<void> getListTaskTypeActive() async {
    TaskTypeService().getListTaskTypeActive().then((value) {
      setState(() {
        filterTaskType = value;
      });
    });
  }

  Future<bool> createEmployee(Map<String, dynamic> employeeData) {
    return EmployeeService().createEmployee(employeeData);
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getProvinces();
    await getListTaskTypeActive();
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
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                      "Thêm nhân viên",
                      style: headingStyle,
                    ),
                    MyInputField(
                      title: "Họ và tên",
                      hint: "Nhập họ và tên của nhân viên",
                      controller: _fullnameController,
                    ),
                    MyInputNumber(
                      title: "Số điện thoại",
                      hint: "Nhập số điện thoại",
                      controller: _phoneController,
                    ),
                    MyInputField(
                      title: "Tỉnh/Thành phố",
                      hint: _selectedProvinces!,
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
                            _selectedProvinces = newValue!['name'];
                            _selectedWar = "";
                            filteredWars = [];
                          });
                          // Lọc danh sách Zone tương ứng với Area đã chọn
                          getDistrictsByProvinceCode(newValue!['code'])
                              .then((value) {
                            setState(() {
                              filteredDistrict = value;
                              // Gọi setState để cập nhật danh sách zone
                              _selectedDistrict =
                                  value.isEmpty ? "Chưa có" : "Chọn";
                            });
                          });
                        },
                        items: filteredProvinces
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(
                              value['name'],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    MyInputField(
                      title: "Quận/Huyện",
                      hint: _selectedDistrict != null ? _selectedDistrict! : "",
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
                            _selectedDistrict = newValue!['name'];
                          });
                          // Lọc danh sách Filed tương ứng với Zone đã chọn
                          getWarsByDistrictCode(newValue!['code'])
                              .then((value) {
                            setState(() {
                              filteredWars = value;
                              _selectedWar = value.isEmpty ? "Chưa có" : "Chọn";
                            });
                          });
                        },
                        items: filteredDistrict
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_selectedDistrict == "Chưa có")
                      Text(
                        "Khu vực chưa có vùng! Hãy chọn khu vực khác",
                        style: TextStyle(
                            fontSize: 14, color: Colors.red, height: 2),
                      ),
                    MyInputField(
                      title: "Phường/Xã",
                      hint: _selectedWar != null ? _selectedWar! : "",
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
                            _selectedWar = newValue!['name'];
                          });
                        },
                        items: filteredWars
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
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
                            "Kĩ năng công việc",
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
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Chọn các kĩ năng phù hợp",
                                    hintStyle:
                                        TextStyle(color: Colors.black45)),
                                initialValue: [],
                                findSuggestions: (String query) {
                                  if (query.length != 0) {
                                    var lowercaseQuery = query.toLowerCase();
                                    return filterTaskType.where((m) {
                                      return m['name']
                                          .toLowerCase()
                                          .contains(query.toLowerCase());
                                    }).toList(growable: false)
                                      ..sort((a, b) => a['name']
                                          .toLowerCase()
                                          .indexOf(lowercaseQuery)
                                          .compareTo(b['name']
                                              .toLowerCase()
                                              .indexOf(lowercaseQuery)));
                                  } else {
                                    return const <Map<String, dynamic>>[];
                                  }
                                },
                                onChanged: (data) {
                                  selectedTaskTypes =
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
                                    onTap: () =>
                                        state.selectSuggestion(material),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
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
                            "Tạo nhân viên",
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
    if (_fullnameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _selectedProvinces != null &&
        _selectedProvinces != "Chọn" &&
        _selectedDistrict != null &&
        _selectedDistrict != "Chọn" &&
        _selectedWar != null &&
        _selectedWar != "Chọn" &&
        selectedTaskTypes.isNotEmpty) {
      if (_phoneController.text.length != 10) {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar(
            context, "Số điện thoại không hợp lệ!", true);
      } else {
        Map<String, dynamic> employeekData = {
          "taskTypeId":
              selectedTaskTypes.map<int>((t) => t['id'] as int).toList(),
          "employee": {
            "name": _fullnameController.text,
            "phoneNumber": _phoneController.text,
            "address": "$_selectedWar, $_selectedDistrict, $_selectedProvinces",
          }
        };
        createEmployee(employeekData).then((value) {
          if (value) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context, "newEmployee");
          }
        }).catchError((e) {
          setState(() {
            isLoading = false;
          });
          SnackbarShowNoti.showSnackbar(context, "Đã xảy ra lỗi!", true);
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(
          context, 'Vui lòng điền đầy đủ thông tin của nhân viên', true);
    }
  }
}