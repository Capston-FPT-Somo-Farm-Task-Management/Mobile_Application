import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';
import 'package:manager_somo_farm_task_management/services/plant_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';

import '../../../componets/input_field.dart';

class CreatePlant extends StatefulWidget {
  final int farmId;

  const CreatePlant({super.key, required this.farmId});

  @override
  CreatePlantState createState() => CreatePlantState();
}

class CreatePlantState extends State<CreatePlant> {
  final TextEditingController _plantCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plantHeightController = TextEditingController();
  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredField = [];
  List<Map<String, dynamic>> filterHabitantType = [];
  String _selectedArea = "";
  String _selectedZone = "";
  String _selectedField = "";
  String _selectedPlantType = "";

  String name = "";
  String externalId = "";
  int? habitantTypeId;
  int? fieldId;
  int? height;
  bool isCreating = false;

  Future<List<Map<String, dynamic>>> getAreasbyFarmId() {
    return AreaService().getAreasActiveByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaId(int areaId) {
    return ZoneService().getZonesbyAreaId(areaId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaPlantId(int areaId) {
    return ZoneService().getZonesbyAreaPlantId(areaId);
  }

  Future<List<Map<String, dynamic>>> getFieldsbyZoneId(int zoneId) {
    return FieldService().getFieldsActivebyZoneId(zoneId);
  }

  Future<List<Map<String, dynamic>>> getPlantTypeFromHabitantType(int id) {
    return HabitantTypeService().getPlantTypeFromHabitantType(id);
  }

  Future<bool> CreatePlant(Map<String, dynamic> plant) {
    return PlantService().createPlant(plant);
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
    getPlantTypeFromHabitantType(widget.farmId).then((p) {
      setState(() {
        filterHabitantType = p;
        _selectedPlantType = "Chọn";
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
                "Thêm cây trồng",
                style: headingStyle,
              ),
              MyInputField(
                title: "Mã cây trồng",
                hint: "Nhập mã cây trồng",
                controller: _plantCodeController,
              ),
              MyInputField(
                title: "Tên cây trồng",
                hint: "Nhập tên cây trồng",
                controller: _nameController,
              ),
              MyInputNumber(
                title: "Độ cao dự kiến của cây trồng (mét)",
                hint: "Nhập độ cao",
                controller: _plantHeightController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loại cây trồng",
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
                                _selectedPlantType = newValue!['name'];
                                habitantTypeId = newValue["id"];
                              });
                            },
                            items: filterHabitantType
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
                            top: 17, left: 16, child: Text(_selectedPlantType))
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
                              getZonesbyAreaPlantId(newValue!['id'])
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
                  "Khu vực chưa có vùng! Hãy chọn khu vực khác",
                  style: TextStyle(fontSize: 14, color: Colors.red, height: 2),
                ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vườn",
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
                  "Vùng bạn chọn chưa có vườn! Hãy chọn vùng khác",
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
                      "Tạo cây trồng",
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
    if (_plantCodeController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _plantHeightController.text.isNotEmpty &&
        _selectedPlantType != "Chọn" &&
        _selectedArea != "Chọn" &&
        _selectedZone != "Chọn" &&
        _selectedZone != "Chưa có" &&
        _selectedField != "Chưa có" &&
        _selectedField != "Chọn") {
      setState(() {
        isCreating = true;
      });
      Map<String, dynamic> plant = {
        'name': _nameController.text,
        'externalId': _plantCodeController.text,
        'height': _plantHeightController.text,
        'habitantTypeId': habitantTypeId,
        'fieldId': fieldId
      };
      CreatePlant(plant).then((value) {
        if (value) {
          Navigator.of(context).pop("ok");
        }
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => PlantPage(farmId: widget.farmId),
        //   ),
        // );
      }).catchError((e) {
        setState(() {
          isCreating = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của cây trồng', true);
    }
  }
}
