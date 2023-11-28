import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_type_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componets/input_field.dart';

class UpdateZone extends StatefulWidget {
  final Map<String, dynamic> zone;
  const UpdateZone({super.key, required this.zone});

  @override
  UpdateZoneState createState() => UpdateZoneState();
}

class UpdateZoneState extends State<UpdateZone> {
  final TextEditingController _titleIdController = TextEditingController();
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _titleNumberController = TextEditingController();

  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filterZoneType = [];
  Map<String, dynamic>? _selectedArea;
  Map<String, dynamic>? _selectedZoneType;

  String name = "";
  int? height;
  int? zoneTypeId;
  int? areaId;
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
            .where((element) => element['id'] == widget.zone['areaId'])
            .firstOrNull;
      });
    });
  }

  Future<void> getZoneTypes(int zoneTypeId, bool init) async {
    ZoneTypeService().getZonesType().then((value) {
      setState(() {
        filterZoneType = value;
        _selectedZoneType = filterZoneType
            .where((element) => element['id'] == widget.zone['zoneTypeId'])
            .firstOrNull;
      });
    });
  }

  Future<bool> UpdateZone(Map<String, dynamic> zone, int id) {
    return ZoneService().UpdateZone(zone, id);
  }

  @override
  void initState() {
    super.initState();
    getFarmId().then((_) {
      getAreas();
      getZoneTypes(widget.zone['zoneTypeId'], true);
    });
    _titleIdController.text = widget.zone['code'];
    _titleNameController.text = widget.zone['name'];
    _titleNumberController.text = widget.zone['farmArea'].toString();
    id = widget.zone['id'];
    zoneTypeId = widget.zone['zoneTypeId'];
    areaId = widget.zone['areaId'];

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
                "Chỉnh sửa vùng",
                style: headingStyle,
              ),
              MyInputField(
                title: "Mã vùng",
                hint: "Nhập mã vùng",
                controller: _titleIdController,
              ),
              MyInputField(
                title: "Tên vùng",
                hint: "Nhập tên vùng",
                controller: _titleNameController,
              ),
              MyInputNumber(
                title: "Diện tích của vùng",
                hint: "Nhập diện tích của vùng",
                controller: _titleNumberController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loại vùng",
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
                        value: _selectedZoneType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedZoneType = newValue;
                            if (newValue != null) {
                              zoneTypeId = newValue['id'];
                            }
                          });
                        },
                        items: filterZoneType
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
                            if (newValue != null) {
                              areaId = newValue['id'];
                            }
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
                      "Chỉnh sửa vùng",
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
        'code': _titleIdController.text,
        'farmArea': _titleNumberController.text,
        'zoneTypeId': zoneTypeId,
        'areaId': areaId,
      };
      UpdateZone(plant, widget.zone['id']).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newZone");
          SnackbarShowNoti.showSnackbar("Cập nhật thành công", false);
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => ZonePage(farmId: farmId!),
          //   ),
          // );
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
