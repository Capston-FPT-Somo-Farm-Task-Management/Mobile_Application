import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plant_page.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';
import 'package:manager_somo_farm_task_management/services/plant_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componets/input_field.dart';

class UpdatePlant extends StatefulWidget {
  final Map<String, dynamic> plant;
  const UpdatePlant({super.key, required this.plant});

  @override
  UpdatePlantState createState() => UpdatePlantState();
}

class UpdatePlantState extends State<UpdatePlant> {
  final TextEditingController _titleIdController = TextEditingController();
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _titleNumberController = TextEditingController();

  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredField = [];
  List<Map<String, dynamic>> filterLivestockType = [];
  Map<String, dynamic>? _selectedArea;
  Map<String, dynamic>? _selectedZone;
  Map<String, dynamic>? _selectedField;
  Map<String, dynamic>? _selectedPlantType;

  String name = "";
  int? height;
  int? habitantTypeId;
  int? fieldId;
  int? farmId;
  int? id;
  bool isLoading = true;
  bool isUpdating = false;

  Future<void> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    setState(() {
      farmId = storedFarmId;
    });
  }

  Future<void> getAreas() async {
    AreaService().getAreasActiveByFarmId(farmId!).then((value) {
      setState(() {
        filteredArea = value;
        _selectedArea = filteredArea
            .where((element) => element['id'] == widget.plant['areaId'])
            .firstOrNull;
      });
    });
  }

  Future<void> getZones(int areaId, bool init) async {
    ZoneService().getZonesbyAreaPlantId(areaId).then((value) {
      setState(() {
        filteredZone = value;
        if (init)
          _selectedZone = filteredZone
              .where((element) => element['id'] == widget.plant['zoneId'])
              .firstOrNull;
      });
    });
  }

  Future<void> getFields(int zoneId, bool init) async {
    FieldService().getFieldsActivebyZoneId(zoneId).then((value) {
      setState(() {
        filteredField = value;
        if (init)
          _selectedField = filteredField
              .where((element) => element['id'] == widget.plant['fieldId'])
              .firstOrNull;
      });
    });
  }

  Future<void> getHabitantTypes(int habitantTypeId, bool init) async {
    HabitantTypeService().getPlantTypeFromHabitantType().then((value) {
      setState(() {
        filterLivestockType = value;
        _selectedPlantType = filterLivestockType
            .where((element) => element['id'] == widget.plant['habitantTypeId'])
            .firstOrNull;
      });
    });
  }

  Future<bool> UpdatePlant(Map<String, dynamic> plant, int id) {
    return PlantService().UpdatePlant(plant, id);
  }

  @override
  void initState() {
    super.initState();
    getFarmId().then((_) {
      getAreas();
      getZones(widget.plant['areaId'], true);
      getFields(widget.plant['zoneId'], true);
      getHabitantTypes(widget.plant['habitantTypeId'], true);
    });
    _titleIdController.text = widget.plant['externalId'];
    _titleNameController.text = widget.plant['name'];
    _titleNumberController.text = widget.plant['height'].toString();
    id = widget.plant['id'];
    habitantTypeId = widget.plant['habitantTypeId'];
    fieldId = widget.plant['fieldId'];

    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (isUpdating) {
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
                "Chỉnh sửa cây trồng",
                style: headingStyle,
              ),
              MyInputField(
                title: "Mã cây trồng",
                hint: "Nhập mã cây trồng",
                controller: _titleIdController,
              ),
              MyInputField(
                title: "Tên cây trồng",
                hint: "Nhập tên cây trồng",
                controller: _titleNameController,
              ),
              MyInputNumber(
                title: "Chiều cao dự kiến của cây trồng (mét)",
                hint: "Nhập Chiều cao dự kiến của cây trồng",
                controller: _titleNumberController,
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
                        value: _selectedPlantType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPlantType = newValue;
                            if (newValue != null) {
                              habitantTypeId = newValue['id'];
                            }
                          });
                        },
                        items: filterLivestockType
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    )
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
                        value: _selectedArea,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedArea = newValue;
                            _selectedZone = null;
                            getZones(newValue!['id'], false);
                            _selectedField = null;
                            getFields(newValue['id'], false);
                          });
                        },
                        items: filteredArea
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    )
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
                        value: _selectedZone,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedZone = newValue;
                            _selectedField = null;
                            getFields(newValue!['id'], false);
                          });
                        },
                        items: filteredZone
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              if (filteredZone.isEmpty)
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
                        value: _selectedField,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedField = newValue;
                            if (newValue != null) {
                              fieldId = newValue['id'];
                            }
                          });
                        },
                        items: filteredField
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    )
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
                      "Chỉnh sửa vật nuôi",
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
        _titleNumberController.text.isNotEmpty) {
      setState(() {
        isUpdating = true;
      });
      Map<String, dynamic> plant = {
        'name': _titleNameController.text,
        'externalId': _titleIdController.text,
        'height': _titleNumberController.text,
        'habitantTypeId': habitantTypeId,
        'fieldId': fieldId,
      };
      UpdatePlant(plant, widget.plant['id']).then((value) {
        if (value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PlantPage(farmId: farmId!),
            ),
          );
        }
      }).catchError((e) {
        setState(() {
          isUpdating = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của vật nuôi', true);
    }
  }
}
