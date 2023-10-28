import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestock_page.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';
import 'package:manager_somo_farm_task_management/services/livestock_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';

import '../../../componets/input_field.dart';

class CreateLiveStock extends StatefulWidget {
  final int farmId;
  const CreateLiveStock({super.key, required this.farmId});

  @override
  CreateLiveStockState createState() => CreateLiveStockState();
}

class CreateLiveStockState extends State<CreateLiveStock> {
  final TextEditingController _titleIdController = TextEditingController();
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _titleNumberController = TextEditingController();

  List<String> filterGender = ["Đực", "Cái"];
  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredField = [];
  List<Map<String, dynamic>> filterLivestock = [];
  String _selectedArea = "";
  String _selectedZone = "";
  String _selectedField = "";
  String _selectedLiveStock = "";
  String _selectedGender = "Đực";

  String name = "";
  String externalId = "";
  int? weight;
  bool gender = true;
  int? habitantTypeId;
  int? fieldId;
  bool isCreating = false;

  Future<List<Map<String, dynamic>>> getAreasbyFarmId() {
    return AreaService().getAreasActiveByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaLivestockId(int areaId) {
    return ZoneService().getZonesbyAreaLivestockId(areaId);
  }

  Future<List<Map<String, dynamic>>> getFieldsbyZoneId(int zoneId) {
    return FieldService().getFieldsActivebyZoneId(zoneId);
  }

  Future<List<Map<String, dynamic>>> getLiveStockTypeFromHabitantType() {
    return HabitantTypeService().getLiveStockTypeFromHabitantType();
  }

  Future<bool> CreateLiveStock(Map<String, dynamic> liveStock) {
    return LiveStockService().CreateLiveStock(liveStock);
  }

  @override
  void initState() {
    super.initState();
    getAreasbyFarmId().then((a) {
      setState(() {
        filteredArea = a;
        _selectedArea = "Chọn";
      });
    });
    getLiveStockTypeFromHabitantType().then((a) {
      setState(() {
        filterLivestock = a;
        _selectedLiveStock = "Chọn";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCreating) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm vật nuôi",
                style: headingStyle,
              ),
              MyInputField(
                title: "Mã vật nuôi",
                hint: "Nhập id vật nuôi",
                controller: _titleIdController,
              ),
              MyInputField(
                title: "Tên vật nuôi",
                hint: "Nhập tên vật nuôi",
                controller: _titleNameController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giới tính vật nuôi",
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
                                _selectedGender = newValue!;
                                if (_selectedGender == 'Đực') {
                                  gender = true;
                                }
                                if (_selectedGender == "Cái") {
                                  gender = false;
                                }
                              });
                            },
                            items: filterGender
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                            top: 17, left: 16, child: Text(_selectedGender))
                      ],
                    ),
                  ],
                ),
              ),
              MyInputNumber(
                title: "Khối lượng dự kiến của vật nuôi (kí)",
                hint: "Nhập khối lượng của vật nuôi",
                controller: _titleNumberController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loại vật nuôi",
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
                                _selectedLiveStock = newValue!['name'];
                                habitantTypeId = newValue['id'];
                              });
                            },
                            items: filterLivestock
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
                            top: 17, left: 16, child: Text(_selectedLiveStock))
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
                      "Khu vực",
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
                                _selectedArea = newValue!['nameCode'];
                                _selectedField = "";
                                filteredField = [];
                              });
                              // Lọc danh sách Zone tương ứng với Area đã chọn
                              getZonesbyAreaLivestockId(newValue!['id'])
                                  .then((value) {
                                setState(() {
                                  filteredZone = value;
                                  // Gọi setState để cập nhật danh sách zone
                                  _selectedZone =
                                      value.isEmpty ? "Chưa có" : "Chọn";
                                });
                              });
                            },
                            items: filteredArea
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (Map<String, dynamic> value) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: value,
                                child: Text(value['nameCode']),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                            top: 17, left: 16, child: Text(_selectedArea))
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
                      "Vùng",
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
                                _selectedZone = newValue!['nameCode'];
                              });
                              // Lọc danh sách Filed tương ứng với Zone đã chọn
                              getFieldsbyZoneId(newValue!['id']).then((value) {
                                setState(() {
                                  filteredField = value;
                                  _selectedField =
                                      value.isEmpty ? "Chưa có" : "Chọn";
                                });
                              });
                            },
                            items: filteredZone
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (Map<String, dynamic> value) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: value,
                                child: Text(value['nameCode']),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                            top: 17, left: 16, child: Text(_selectedZone))
                      ],
                    ),
                  ],
                ),
              ),
              if (_selectedZone == "Chưa có")
                Text(
                  "Hãy chọn khu vực khác",
                  style: TextStyle(fontSize: 11, color: Colors.red, height: 2),
                ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chuồng",
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
                                _selectedField = newValue!['nameCode'];
                                fieldId = newValue['id'];
                              });
                            },
                            items: filteredField
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (Map<String, dynamic> value) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: value,
                                child: Text(value['nameCode']),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                            top: 17, left: 16, child: Text(_selectedField))
                      ],
                    ),
                  ],
                ),
              ),
              if (_selectedField == "Chưa có")
                Text(
                  "Vùng bạn chọn chưa có chuồng! Hãy chọn vùng khác",
                  style: TextStyle(fontSize: 14, color: Colors.red, height: 2),
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
                      "Tạo vật nuôi",
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
    if (_titleIdController.text.isNotEmpty &&
        _titleNameController.text.isNotEmpty &&
        _titleNumberController.text.isNotEmpty &&
        _selectedArea != "Chọn" &&
        _selectedZone != "Chọn" &&
        _selectedZone != "Chưa có" &&
        _selectedField != "Chưa có" &&
        _selectedField != "Chọn") {
      setState(() {
        isCreating = true;
      });
      Map<String, dynamic> liveStock = {
        'name': _titleNameController.text,
        'externalId': _titleIdController.text,
        'weight': _titleNumberController.text,
        'habitantTypeId': habitantTypeId,
        'fieldId': fieldId,
        'gender': gender,
      };
      CreateLiveStock(liveStock).then((value) {
        if (value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LiveStockPage(farmId: widget.farmId),
            ),
          );
        }
      }).catchError((e) {
        setState(() {
          isCreating = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của vật nuôi', true);
    }
  }
}
