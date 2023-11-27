import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';
import 'package:manager_somo_farm_task_management/services/livestock_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componets/input_field.dart';

class UpdateLiveStock extends StatefulWidget {
  final Map<String, dynamic> livestock;
  const UpdateLiveStock({super.key, required this.livestock});

  @override
  UpdateLiveStockState createState() => UpdateLiveStockState();
}

class UpdateLiveStockState extends State<UpdateLiveStock> {
  final TextEditingController _titleIdController = TextEditingController();
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _titleNumberController = TextEditingController();

  List<String> filterGender = ["Đực", "Cái"];
  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredField = [];
  List<Map<String, dynamic>> filterLivestockType = [];
  Map<String, dynamic>? _selectedArea;
  Map<String, dynamic>? _selectedZone;
  Map<String, dynamic>? _selectedField;
  Map<String, dynamic>? _selectedLiveStockType;
  String _selectedGender = "Đực";

  String name = "";
  int? weight;
  bool gender = true;
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
            .where((element) => element['id'] == widget.livestock['areaId'])
            .firstOrNull;
      });
    });
  }

  Future<void> getZones(int areaId, bool init) async {
    ZoneService().getZonesbyAreaLivestockId(areaId).then((value) {
      setState(() {
        filteredZone = value;
        if (init)
          _selectedZone = filteredZone
              .where((element) => element['id'] == widget.livestock['zoneId'])
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
              .where((element) => element['id'] == widget.livestock['fieldId'])
              .firstOrNull;
      });
    });
  }

  Future<void> getHabitantTypes(int habitantTypeId, bool init) async {
    HabitantTypeService()
        .getLiveStockTypeFromHabitantType(farmId!)
        .then((value) {
      setState(() {
        filterLivestockType = value;
        _selectedLiveStockType = filterLivestockType
            .where((element) =>
                element['id'] == widget.livestock['habitantTypeId'])
            .firstOrNull;
      });
    });
  }

  Future<bool> UpdateLiveStock(Map<String, dynamic> liveStock, int id) {
    return LiveStockService().UpdateLiveStock(liveStock, id);
  }

  @override
  void initState() {
    super.initState();
    getFarmId().then((_) {
      getAreas();
      getZones(widget.livestock['areaId'], true);
      getFields(widget.livestock['zoneId'], true);
      getHabitantTypes(widget.livestock['habitantTypeId'], true);
    });
    _titleIdController.text = widget.livestock['externalId'];
    _titleNameController.text = widget.livestock['name'];
    _titleNumberController.text = widget.livestock['weight'].toString();
    id = widget.livestock['id'];
    habitantTypeId = widget.livestock['habitantTypeId'];
    fieldId = widget.livestock['fieldId'];
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
                "Chỉnh sửa vật nuôi",
                style: headingStyle,
              ),
              MyInputField(
                title: "Mã vật nuôi",
                hint: "Nhập mã vật nuôi",
                controller: _titleIdController,
              ),
              MyInputField(
                title: "Tên vật nuôi",
                hint: "Nhập tên vật nuôi",
                controller: _titleNameController,
              ),
              MyInputField(
                title: "Giới tính vật nuôi",
                hint: _selectedGender,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  underline: Container(height: 0),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
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
                        value: _selectedLiveStockType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLiveStockType = newValue;
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
                            child: Text(value['nameCode']),
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
                            child: Text(value['nameCode']),
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
                            child: Text(value['nameCode']),
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
      Map<String, dynamic> liveStock = {
        'name': _titleNameController.text,
        'externalId': _titleIdController.text,
        'weight': _titleNumberController.text,
        'habitantTypeId': habitantTypeId,
        'fieldId': fieldId,
        'gender': gender,
      };
      UpdateLiveStock(liveStock, widget.livestock['id']).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newZone");
          SnackbarShowNoti.showSnackbar("Cập nhật thành công", false);

          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => LiveStockPage(farmId: farmId!),
          //   ),
          // );
        }
      }).catchError((e) {
        setState(() {
          isUpdating = true;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của vật nuôi', true);
    }
  }
}
