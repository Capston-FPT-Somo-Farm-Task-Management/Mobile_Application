import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componets/input_field.dart';

class UpdatePlantField extends StatefulWidget {
  final Map<String, dynamic> plantFied;
  const UpdatePlantField({super.key, required this.plantFied});

  @override
  UpdatePlantFieldState createState() => UpdatePlantFieldState();
}

class UpdatePlantFieldState extends State<UpdatePlantField> {
  final TextEditingController _titleIdController = TextEditingController();
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _titleAreaController = TextEditingController();

  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filteredZone = [];
  Map<String, dynamic>? _selectedArea;
  Map<String, dynamic>? _selectedZone;

  String name = "";
  int? status;
  int? farmId;
  int? id;
  int? zoneId;
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
            .where((element) => element['id'] == widget.plantFied['areaId'])
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
              .where((element) => element['id'] == widget.plantFied['zoneId'])
              .firstOrNull;
      });
    });
  }

  Future<bool> UpdateField(Map<String, dynamic> field, int id) {
    return FieldService().UpdateField(field, id);
  }

  @override
  void initState() {
    super.initState();
    getFarmId().then((_) {
      getAreas();
      getZones(widget.plantFied['areaId'], true);
    });
    _titleIdController.text = widget.plantFied['code'];
    _titleNameController.text = widget.plantFied['name'];
    _titleAreaController.text = widget.plantFied['area'].toString();
    id = widget.plantFied['id'];
    zoneId = widget.plantFied['zoneId'];
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
                "Chỉnh sửa vườn cây",
                style: headingStyle,
              ),
              MyInputField(
                title: "Mã vườn",
                hint: "Nhập mã vườn",
                controller: _titleIdController,
              ),
              MyInputField(
                title: "Tên vườn",
                hint: "Nhập tên vườn",
                controller: _titleNameController,
              ),
              MyInputNumber(
                title: "Diện tích của vườn (mét vuông)",
                hint: "Nhập diện tích của vườn",
                controller: _titleAreaController,
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
                            if (newValue != null) {
                              zoneId = newValue['id'];
                            }
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
                      "Chỉnh sửa vườn",
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
        _titleAreaController.text.isNotEmpty) {
      setState(() {
        isUpdating = true;
      });
      Map<String, dynamic> field = {
        'name': _titleNameController.text,
        'code': _titleIdController.text,
        'area': _titleAreaController.text,
        'zoneId': zoneId,
        'status': 0,
      };
      UpdateField(field, widget.plantFied['id']).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newZone");
          SnackbarShowNoti.showSnackbar("Cập nhật thành công", false);

          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => PlantFieldPage(),
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
