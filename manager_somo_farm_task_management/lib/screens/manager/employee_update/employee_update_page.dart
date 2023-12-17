import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/media_picker.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';

import 'package:manager_somo_farm_task_management/services/provinces_service.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../../../componets/input_field.dart';

class UpdateEmployee extends StatefulWidget {
  final int farmId;
  final Map<String, dynamic> employee;
  const UpdateEmployee(
      {super.key, required this.farmId, required this.employee});

  @override
  UpdateEmployeeState createState() => UpdateEmployeeState();
}

class UpdateEmployeeState extends State<UpdateEmployee> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  List<Map<String, dynamic>> filteredProvinces = [];
  List<Map<String, dynamic>> filteredDistrict = [];
  List<Map<String, dynamic>> filteredWars = [];
  List<Map<String, dynamic>> filterTaskType = [];
  List<Map<String, dynamic>> selectedTaskTypes = [];
  List<String> filterGender = ["Nam", "Nữ"];
  List<AssetEntity> selectedAssetList = [];
  Map<String, dynamic>? _selectedProvinces;
  Map<String, dynamic>? _selectedDistrict;
  Map<String, dynamic>? _selectedWar;
  Key _keyChange = UniqueKey();
  String? _selectedGender;
  String? provinces, district, ward;
  String? urlImage;
  File? selectedFile;
  String hintImg = "Tải ảnh lên";
  String? _birthday;
  DateTime? _dateTime;
  bool isLoading = true;
  Future<void> splitAddress(String address) async {
    // Tách địa chỉ thành các phần: Xã, Huyện, Tỉnh
    List<String> parts = await address.split(', ');

    setState(() {
      ward = parts[0];
      district = parts[1];
      provinces = parts[2];
    });
  }

  Future<void> getProvinces() async {
    await ProvincesService().getProvinces().then((value) {
      setState(() {
        filteredProvinces = value;
        _selectedProvinces = filteredProvinces
            .where((element) => element['name'] == provinces)
            .firstOrNull;
      });
    });
  }

  Future<void> getDistricts(int code) async {
    await ProvincesService().getDistrictsByProvinceCode(code).then((value) {
      setState(() {
        filteredDistrict = value;
        _selectedDistrict = filteredDistrict
            .where((element) => element['name'] == district)
            .firstOrNull;
      });
    });
  }

  Future<void> getWard(int code) async {
    await ProvincesService().getWarsByDistrictCode(code).then((value) {
      setState(() {
        filteredWars = value;
        _selectedWar = filteredWars
            .where((element) => element['name'] == ward)
            .firstOrNull;
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
        selectedTaskTypes = filterTaskType
            .where((element) =>
                widget.employee['taskTypeId'].contains(element['id']))
            .toList();
        isLoading = false;
      });
    });
  }

  Future<bool> updateEmployee(
      int employeeId, Map<String, dynamic> employeeData, File? image) {
    return EmployeeService().updateEmployee(employeeId, employeeData, image);
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
      if (result != null) {
        selectedAssetList = result;
        urlImage = "";
      }
    });
  }

  Future convertAssetsToFiles(List<AssetEntity> assetEntities) async {
    for (var i = 0; i < assetEntities.length; i++) {
      final File? file = await assetEntities[i].originFile;
      setState(() {
        selectedFile = file!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    splitAddress(widget.employee['address']).then((_) {
      _initializeData();
    });

    _codeController.text = widget.employee['code'];
    _fullnameController.text = widget.employee['name'];
    _phoneController.text = widget.employee['phoneNumber'];
    _selectedGender = widget.employee['gender'] == "Male" ? "Nam" : "Nữ";
    urlImage = widget.employee['avatar'];
    _birthday = widget.employee['dateOfBirth'];
    _dateTime = DateTime.parse(_birthday!);
  }

  Future<void> _initializeData() async {
    await getProvinces().then((_) {
      getDistricts(_selectedProvinces!['code']).then((_) {
        getWard(_selectedDistrict!['code']);
      });
    });
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
                        hint: hintImg,
                        widget: Icon(Icons.add_photo_alternate, size: 30),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (selectedAssetList.length == 1)
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.height * 0.2,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Positioned.fill(
                            child: AssetEntityImage(
                              selectedAssetList[0],
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
                        ),
                      ),
                    if (urlImage!.isNotEmpty)
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.height * 0.2,
                          child: Positioned.fill(
                            child: Image.network(
                              urlImage!,
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
                        ),
                      ),
                    const SizedBox(height: 40),
                    const Divider(
                      color: Colors.grey, // Đặt màu xám
                      height: 1, // Độ dày của dòng gạch
                      thickness: 1, // Độ dày của dòng gạch (có thể thay đổi)
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
                          : DateFormat('dd/MM/yyyy').format(_dateTime!),
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
                              _dateTime = selectedDate;
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
                                  value: _selectedGender,
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
                              // Positioned(
                              //     top: 17,
                              //     left: 16,
                              //     child: Text(_selectedProvinces!['name']))
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
                                  value: _selectedProvinces,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedProvinces = newValue;
                                      _selectedWar = null;
                                      _selectedDistrict = null;
                                    });
                                    // Lọc danh sách Zone tương ứng với Area đã chọn
                                    getDistrictsByProvinceCode(
                                            newValue!['code'])
                                        .then((value) {
                                      setState(() {
                                        filteredDistrict = value;
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
                              // Positioned(
                              //     top: 17,
                              //     left: 16,
                              //     child: Text(_selectedProvinces!['name']))
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
                                  value: _selectedDistrict,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedDistrict = newValue;
                                      _selectedWar = null;
                                    });
                                    // Lọc danh sách Filed tương ứng với Zone đã chọn
                                    getWarsByDistrictCode(newValue!['code'])
                                        .then((value) {
                                      setState(() {
                                        filteredWars = value;
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
                              // Positioned(
                              //     top: 17,
                              //     left: 16,
                              //     child: Text(_selectedDistrict != null
                              //         ? _selectedDistrict!['name']
                              //         : ""))
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
                                  value: _selectedWar,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedWar = newValue;
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
                              // Positioned(
                              //     top: 17,
                              //     left: 16,
                              //     child: Text(_selectedWar != null
                              //         ? _selectedWar!['name']
                              //         : ""))
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
                            "Lưu chỉnh sửa",
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
        selectedTaskTypes.isNotEmpty) {
      if (_phoneController.text.length != 10) {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar("Số điện thoại không hợp lệ!", true);
      } else {
        Map<String, dynamic> employeekData = {
          "taskTypeIds":
              selectedTaskTypes.map<int>((t) => t['id'] as int).toList(),
          "employee": {
            "name": _fullnameController.text,
            "phoneNumber": _phoneController.text,
            "address":
                "${_selectedWar!['name']}, ${_selectedDistrict!['name']}, ${_selectedProvinces!['name']}",
            "farmId": widget.farmId,
            "code": _codeController.text,
            "gender": _selectedGender == "Nữ",
            "dateOfBirth":
                DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(_dateTime!)
          }
        };
        if (selectedAssetList.isNotEmpty)
          convertAssetsToFiles(selectedAssetList).then((value) {
            updateEmployee(widget.employee['id'], employeekData, selectedFile!)
                .then((value) {
              if (value) {
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context, "newEmployee");
                SnackbarShowNoti.showSnackbar("Cập nhật thành công", false);
              }
            }).catchError((e) {
              setState(() {
                isLoading = false;
              });
              SnackbarShowNoti.showSnackbar(e.toString(), true);
            });
          });
        else {
          updateEmployee(widget.employee['id'], employeekData, null)
              .then((value) {
            if (value) {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context, "newEmployee");
              SnackbarShowNoti.showSnackbar("Cập nhật thành công", false);
            }
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
            SnackbarShowNoti.showSnackbar(e.toString(), true);
          });
        }
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
