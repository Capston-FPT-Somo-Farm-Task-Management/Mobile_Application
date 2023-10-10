import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_type_service.dart';

import '../../../componets/input_field.dart';

class CreateZone extends StatefulWidget {
  final int farmId;
  const CreateZone({super.key, required this.farmId});

  @override
  CreateZoneState createState() => CreateZoneState();
}

class CreateZoneState extends State<CreateZone> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fZoneController = TextEditingController();
  final TextEditingController _fZoneCodeController = TextEditingController();
  bool isLoading = false;
  String _selectedArea = "";
  int? _selectedAreaId;
  List<Map<String, dynamic>> filteredArea = [];
  String _selectedZoneType = "";
  int? _selectedZoneTypeId;
  List<Map<String, dynamic>> filteredZoneType = [];

  Future<void> getAreasbyFarmId() async {
    AreaService().getAreasActiveByFarmId(widget.farmId).then((value) {
      setState(() {
        filteredArea = value;
        _selectedArea = "Chọn";
      });
    });
  }

  Future<void> getZoneType() async {
    ZoneTypeService().getZonesType().then((value) {
      setState(() {
        filteredZoneType = value;
        _selectedZoneType = "Chọn";
      });
    });
  }

  Future<bool> createZone(Map<String, dynamic> zoneData) {
    return ZoneService().createZone(zoneData);
  }

  Future<void> _initializeData() async {
    await getZoneType();
    await getAreasbyFarmId();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
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
                      "Thêm vùng",
                      style: headingStyle,
                    ),
                    MyInputField(
                      title: "Mã vùng",
                      hint: "Nhập mã vùng",
                      controller: _fZoneCodeController,
                    ),
                    MyInputField(
                      title: "Tên vùng",
                      hint: "Nhập tên vùng",
                      controller: _nameController,
                    ),
                    MyInputNumber(
                      title: "Diện tích (mét vuông)",
                      hint: "Nhập diện tích",
                      controller: _fZoneController,
                    ),
                    MyInputField(
                      title: "Loại vùng",
                      hint: _selectedZoneType,
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
                            _selectedZoneType = newValue!['name'];
                            _selectedZoneTypeId = newValue['id'];
                          });
                        },
                        items: filteredZoneType
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
                      title: "Vùng thuộc khu vực",
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
                            _selectedAreaId = newValue['id'];
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
                            "Tạo khu vực",
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
    if (_nameController.text.isNotEmpty &&
        _fZoneController.text.isNotEmpty &&
        _fZoneCodeController.text.isNotEmpty &&
        _selectedArea != "Chọn" &&
        _selectedZoneType != "Chọn") {
      Map<String, dynamic> zoneData = {
        "code": _fZoneCodeController.text,
        "name": _nameController.text,
        "farmArea": _fZoneController.text,
        "zoneTypeId": _selectedZoneTypeId,
        "areaId": _selectedAreaId
      };
      createZone(zoneData).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newArea");
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin!', true);
    }
  }
}
