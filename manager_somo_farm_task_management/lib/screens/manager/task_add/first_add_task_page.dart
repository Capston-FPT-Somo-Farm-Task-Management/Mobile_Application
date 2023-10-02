import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_add/second_add_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_add/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/livestock_service.dart';
import 'package:manager_somo_farm_task_management/services/plant_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';

class FirstAddTaskPage extends StatefulWidget {
  final int farmId;
  final bool isOne;
  final bool isPlant;
  const FirstAddTaskPage(
      {super.key,
      required this.farmId,
      required this.isOne,
      required this.isPlant});

  @override
  State<FirstAddTaskPage> createState() => _FirstAddTaskPage();
}

class _FirstAddTaskPage extends State<FirstAddTaskPage> {
  String _selectedArea = "";
  List<Map<String, dynamic>> filteredArea = [];
  String _selectedZone = "";
  String _selectedField = "";
  String _selectedExternalId = "";
  int? fiedlId;
  int? plantId;
  int? liveStockId;
  int? otherId;
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredField = [];
  List<Map<String, dynamic>> filteredExternalId = [];

  Future<List<Map<String, dynamic>>> getAreasbyFarmId() {
    return AreaService().getAreasByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaId(int areaId) {
    return ZoneService().getZonesbyAreaId(areaId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaPlantId(int areaId) {
    return ZoneService().getZonesbyAreaPlantId(areaId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaLivestockId(int areaId) {
    return ZoneService().getZonesbyAreaLivestockId(areaId);
  }

  Future<List<Map<String, dynamic>>> getFieldsbyZoneId(int zoneId) {
    return FieldService().getFieldsbyZoneId(zoneId);
  }

  Future<List<Map<String, dynamic>>> getPlantExternalIdsbyFieldId(int fieldId) {
    return PlantService().getPlantExternalIdsByFieldId(fieldId);
  }

  Future<List<Map<String, dynamic>>> getLiveStockExternalIdsbyFieldId(
      int fieldId) {
    return LiveStockService().getLiveStockExternalIdsByFieldId(fieldId);
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
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm công việc (1/3)",
                style: headingStyle,
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
                      _selectedField = "";
                      _selectedExternalId = "";
                      filteredField = [];
                      filteredExternalId = [];
                    });
                    // Lọc danh sách Zone tương ứng với Area đã chọn
                    widget.isPlant
                        ? getZonesbyAreaPlantId(newValue!['id']).then((value) {
                            setState(() {
                              filteredZone = value;
                              // Gọi setState để cập nhật danh sách zone
                              _selectedZone =
                                  value.isEmpty ? "Chưa có" : "Chọn";
                            });
                          })
                        : getZonesbyAreaLivestockId(newValue!['id'])
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
                      _selectedExternalId = "";
                      filteredExternalId = [];
                    });
                    // Lọc danh sách Filed tương ứng với Zone đã chọn
                    getFieldsbyZoneId(newValue!['id']).then((value) {
                      setState(() {
                        filteredField = value;
                        _selectedField = value.isEmpty ? "Chưa có" : "Chọn";
                      });
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
                  "Hãy chọn khu vực khác",
                  style: TextStyle(fontSize: 11, color: Colors.red, height: 2),
                ),
              MyInputField(
                title: widget.isPlant ? "Vườn" : "Chuồng",
                hint: _selectedField,
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
                      _selectedField = newValue!['name'];
                      fiedlId = newValue['id'];
                    });
                    if (widget.isOne) {
                      widget.isPlant
                          ? getPlantExternalIdsbyFieldId(newValue!['id'])
                              .then((value) {
                              setState(() {
                                filteredExternalId = value;
                                _selectedExternalId =
                                    value.isEmpty ? "Chưa có" : "Chọn";
                              });
                            })
                          : getLiveStockExternalIdsbyFieldId(newValue!['id'])
                              .then((value) {
                              setState(() {
                                filteredExternalId = value;
                                _selectedExternalId =
                                    value.isEmpty ? "Chưa có" : "Chọn";
                              });
                            });
                    }
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
              ),
              if (_selectedField == "Chưa có")
                Text(
                  "Hãy chọn vùng khác",
                  style: TextStyle(fontSize: 11, color: Colors.red, height: 2),
                ),
              if (widget.isOne)
                MyInputField(
                  title: widget.isPlant ? "Mã cây trồng" : "Mã vật nuôi",
                  hint: _selectedExternalId,
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
                        _selectedExternalId = newValue!['externalId'];
                        widget.isPlant
                            ? plantId = newValue['id']
                            : liveStockId = newValue['id'];
                      });
                    },
                    items: filteredExternalId
                        .map<DropdownMenuItem<Map<String, dynamic>>>(
                            (Map<String, dynamic> value) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: value,
                        child: Text(value['externalId']),
                      );
                    }).toList(),
                  ),
                ),
              if (_selectedExternalId == "Chưa có")
                widget.isPlant
                    ? Text(
                        "Hãy chọn vườn khác",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      )
                    : Text(
                        "Hãy chọn chuồng khác",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  GestureDetector(
                    onTap: () {
                      validate(context, widget.isPlant);
                    },
                    child: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kPrimaryColor,
                      ),
                      alignment: Alignment
                          .center, // Đặt alignment thành Alignment.center
                      child: const Text(
                        "Tiếp theo",
                        style: TextStyle(
                          color: kTextWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  validate(context, isPlant) {
    if (_selectedArea != "Chọn" &&
        _selectedZone != "Chọn" &&
        _selectedZone != "Chưa có" &&
        _selectedField != "Chưa có" &&
        _selectedField != "Chọn" &&
        _selectedExternalId != "Chọn" &&
        _selectedExternalId != "Chưa có") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SecondAddTaskPage(
            fieldId: fiedlId!,
            otherId: null,
            liveStockId: liveStockId,
            plantId: plantId,
            isPlant: widget.isPlant,
          ),
        ),
      );
    } else {
      SnackbarShowNoti.showSnackbar(context, "Dữ liệu không hợp lệ", true);
    }
  }
}
