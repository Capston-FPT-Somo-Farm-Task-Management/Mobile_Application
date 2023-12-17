import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/imange_list_selected.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/media_picker.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';

import 'package:manager_somo_farm_task_management/services/provinces_service.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../componets/input_field.dart';

class CreateEmployee extends StatefulWidget {
  final int farmId;
  const CreateEmployee({super.key, required this.farmId});

  @override
  CreateEmployeeState createState() => CreateEmployeeState();
}

class CreateEmployeeState extends State<CreateEmployee> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  DateTime? _birthday;
  List<Map<String, dynamic>> filteredProvinces = [];
  List<Map<String, dynamic>> filteredDistrict = [];
  List<Map<String, dynamic>> filteredWars = [];
  List<Map<String, dynamic>> filterTaskType = [];
  List<Map<String, dynamic>> selectedTaskTypes = [];
  List<AssetEntity> selectedAssetList = [];
  List<String> filterGender = ["Nam", "Nữ"];
  String? _selectedGender = "Chọn";
  String? _selectedProvinces = "Chọn";
  String? _selectedDistrict;
  String? _selectedWar;
  bool isLoading = false;
  File? selectedFiles;
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

  Future<bool> createEmployee(Map<String, dynamic> employeeData, File image) {
    return EmployeeService().createEmployee(employeeData, image);
  }

  Future convertAssetsToFiles(List<AssetEntity> assetEntities) async {
    for (var i = 0; i < assetEntities.length; i++) {
      final File? file = await assetEntities[i].originFile;
      setState(() {
        selectedFiles = file!;
      });
    }
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

  Future pickAssets({
    required int maxCount,
    required RequestType requestType,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MediaPicker(maxCount, requestType, selectedAssetList);
        },
      ),
    );
    setState(() {
      if (result != null) selectedAssetList = result;
    });
  }

  Widget buildAssetWidget(AssetEntity assetEntity) {
    int indexInSelectedList = selectedAssetList.indexOf(assetEntity);
    return GestureDetector(
      onTap: () async {
        //_showFullSizeImage(assetEntity);
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageListSelectedPage(
                selectedAssetList: selectedAssetList,
                indexFocus: indexInSelectedList),
          ),
        );
        setState(() {
          if (result != null) selectedAssetList = result;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AssetEntityImage(
              assetEntity,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(1000),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
                    GestureDetector(
                      onTap: () {
                        pickAssets(
                          maxCount: 1,
                          requestType: RequestType.image,
                        );
                        setState(() {});
                      },
                      child: MyInputField(
                        title: "Chọn ảnh",
                        hint: "Tải ảnh lên",
                        widget: Icon(Icons.add_photo_alternate, size: 30),
                      ),
                    ),
                    if (selectedAssetList.length == 1)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: buildAssetWidget(selectedAssetList[0]),
                      ),
                    MyInputField(
                      maxLength: 20,
                      title: "Mã nhân viên",
                      hint: "Nhập mã nhân viên",
                      controller: _codeController,
                    ),
                    MyInputField(
                      maxLength: 100,
                      title: "Họ và tên",
                      hint: "Nhập họ và tên của nhân viên",
                      controller: _fullnameController,
                    ),
                    MyInputNumber(
                      maxLength: 10,
                      title: "Số điện thoại",
                      hint: "Nhập số điện thoại",
                      controller: _phoneController,
                    ),
                    MyInputField(
                      title: "Ngày sinh",
                      hint: _birthday == null
                          ? "dd/MM/yyyy"
                          : DateFormat('dd/MM/yyyy').format(_birthday!),
                      widget: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());
                          if (selectedDate != null) {
                            setState(() {
                              _birthday = selectedDate;
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Giới tính",
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
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                  items: filterGender
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  top: 17,
                                  left: 16,
                                  child: Text(_selectedGender!))
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
                            "Tỉnh/Thành phố",
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
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedProvinces = newValue!['name'];
                                      _selectedWar = "";
                                      filteredWars = [];
                                    });
                                    // Lọc danh sách Zone tương ứng với Area đã chọn
                                    getDistrictsByProvinceCode(
                                            newValue!['code'])
                                        .then((value) {
                                      setState(() {
                                        filteredDistrict = value;
                                        // Gọi setState để cập nhật danh sách zone
                                        _selectedDistrict =
                                            value.isEmpty ? "Chưa có" : "Chọn";
                                      });
                                    });
                                  },
                                  items: filteredProvinces.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: value,
                                      child: Text(
                                        value['name'],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  top: 17,
                                  left: 16,
                                  child: Text(_selectedProvinces!))
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
                            "Quận/Huyện",
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
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedDistrict = newValue!['name'];
                                    });
                                    // Lọc danh sách Filed tương ứng với Zone đã chọn
                                    getWarsByDistrictCode(newValue!['code'])
                                        .then((value) {
                                      setState(() {
                                        filteredWars = value;
                                        _selectedWar =
                                            value.isEmpty ? "Chưa có" : "Chọn";
                                      });
                                    });
                                  },
                                  items: filteredDistrict.map<
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
                                  child: Text(_selectedDistrict != null
                                      ? _selectedDistrict!
                                      : ""))
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_selectedDistrict == "Chưa có")
                      Text(
                        "Khu vực chưa có vùng! Hãy chọn khu vực khác",
                        style: TextStyle(
                            fontSize: 14, color: Colors.red, height: 2),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phường/Xã",
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
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedWar = newValue!['name'];
                                    });
                                  },
                                  items: filteredWars.map<
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
                                  child: Text(_selectedWar != null
                                      ? _selectedWar!
                                      : ""))
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
                            "Kĩ năng công việc",
                            style: titileStyle,
                          ),
                          Container(
                            height: 52,
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
                                hint: "Chọn kĩ năng phù hợp",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                showClearIcon: false,
                                selectedOptions:
                                    selectedTaskTypes.map((taskType) {
                                  return ValueItem<int>(
                                    label: taskType['name'],
                                    value: taskType['id'],
                                  );
                                }).toList(),
                                onOptionSelected:
                                    (List<ValueItem<int>> selectedOptions) {
                                  // Handle selected options
                                  selectedTaskTypes =
                                      selectedOptions.map((item) {
                                    return {
                                      'name': item.label,
                                      'id': item.value,
                                    };
                                  }).toList();
                                },
                                options: filterTaskType.map((taskType) {
                                  return ValueItem<int>(
                                    label: taskType['name'],
                                    value: taskType['id'],
                                  );
                                }).toList(),
                                selectionType: SelectionType.multi,
                                chipConfig:
                                    const ChipConfig(wrapType: WrapType.wrap),
                                dropdownHeight: 200,
                                optionTextStyle: const TextStyle(fontSize: 16),
                                selectedOptionIcon:
                                    const Icon(Icons.check_circle),
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
        _codeController.text.isNotEmpty &&
        _selectedProvinces != null &&
        _selectedProvinces != "Chọn" &&
        _selectedDistrict != null &&
        _selectedDistrict != "Chọn" &&
        _selectedWar != null &&
        _selectedWar != "Chọn" &&
        _selectedGender != null &&
        _selectedGender != "Chọn" &&
        selectedTaskTypes.isNotEmpty) {
      if (_phoneController.text.length != 10) {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar("Số điện thoại không hợp lệ!", true);
      } else {
        Map<String, dynamic> employeekData = {
          "taskTypeId":
              selectedTaskTypes.map<int>((t) => t['id'] as int).toList(),
          "employee": {
            "name": _fullnameController.text,
            "phoneNumber": _phoneController.text,
            "address": "$_selectedWar, $_selectedDistrict, $_selectedProvinces",
            "farmId": widget.farmId,
            "code": _codeController.text,
            "gender": _selectedGender == "Nữ",
            "dateOfBirth": _birthday
          }
        };
        convertAssetsToFiles(selectedAssetList).then((value) {
          createEmployee(employeekData, selectedFiles!).then((value) {
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
            SnackbarShowNoti.showSnackbar(e.toString(), true);
          });
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của nhân viên', true);
    }
  }
}
