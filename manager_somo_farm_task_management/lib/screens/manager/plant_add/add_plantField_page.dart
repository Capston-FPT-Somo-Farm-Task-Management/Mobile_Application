import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plantField_page.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';

import '../../../componets/input_field.dart';
import '../../../componets/input_number.dart';

class CreatePlantField extends StatefulWidget {
  final int farmId;
  const CreatePlantField({super.key, required this.farmId});

  @override
  CreatePlantFieldState createState() => CreatePlantFieldState();
}

class CreatePlantFieldState extends State<CreatePlantField> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _fieldCodeController = TextEditingController();

  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredPlantType = [];
  String _selectedArea = "";
  String _selectedZone = "";

  int? status;
  int? zoneId;
  bool isCreating = false;

  Future<List<Map<String, dynamic>>> getAreasbyFarmId() {
    return AreaService().getAreasActiveByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaPlantId(int areaId) {
    return ZoneService().getZonesbyAreaPlantId(areaId);
  }

  Future<List<Map<String, dynamic>>> getPlantTypeFromHabitantType() {
    return HabitantTypeService().getPlantTypeFromHabitantType();
  }

  Future<bool> CreatePlantField(Map<String, dynamic> plant) {
    return FieldService().CreateField(plant);
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
                "Thêm vườn cây",
                style: headingStyle,
              ),
              MyInputField(
                title: "Mã vườn",
                hint: "Nhập mã vườn cây",
                controller: _fieldCodeController,
              ),
              MyInputField(
                title: "Tên vườn",
                hint: "Nhập tên vườn cây",
                controller: _nameController,
              ),
              MyInputNumber(
                title: "Nhập diện tích của vườn (mét vuông)",
                hint: "Nhập diện tích",
                controller: _areaController,
              ),
              MyInputField(
                title: "Khu vực",
                hint: _selectedArea,
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
                      _selectedArea = newValue!['name'];
                    });
                    // Lọc danh sách Zone tương ứng với Area đã chọn
                    getZonesbyAreaPlantId(newValue!['id']).then((value) {
                      setState(() {
                        filteredZone = value;
                        // Gọi setState để cập nhật danh sách zone
                        _selectedZone = value.isEmpty ? "Chưa có" : "Chọn";
                      });
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
              ),
              MyInputField(
                title: "Vùng",
                hint: _selectedZone,
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
                      _selectedZone = newValue!['name'];
                      zoneId = newValue['id'];
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
              ),
              if (_selectedZone == "Chưa có")
                Text(
                  "Khu vực chưa có vùng! Hãy chọn khu vực khác",
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
                      "Tạo vườn cây",
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
    if (_nameController.text.isNotEmpty &&
        _areaController.text.isNotEmpty &&
        _fieldCodeController.text.isNotEmpty &&
        _selectedArea != "Chọn" &&
        _selectedZone != "Chọn" &&
        _selectedZone != "Chưa có") {
      setState(() {
        isCreating = true;
      });
      Map<String, dynamic> plant = {
        'code': _fieldCodeController.text,
        'name': _nameController.text,
        'status': 0,
        'area': _areaController.text,
        'zoneId': zoneId
      };
      CreatePlantField(plant).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PlantFieldPage(farmId: widget.farmId),
          ),
        );
      }).catchError((e) {
        setState(() {
          isCreating = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
    }
  }
}
