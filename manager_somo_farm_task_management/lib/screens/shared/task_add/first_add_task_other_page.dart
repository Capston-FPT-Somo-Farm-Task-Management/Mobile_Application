import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/second_add_task_page.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';

class FirstAddTaskOtherPage extends StatefulWidget {
  final int farmId;
  const FirstAddTaskOtherPage({super.key, required this.farmId});

  @override
  State<FirstAddTaskOtherPage> createState() => _FirstAddTaskOtherPage();
}

class _FirstAddTaskOtherPage extends State<FirstAddTaskOtherPage> {
  final TextEditingController _addressDetailController =
      TextEditingController();
  String _selectedArea = "";
  List<Map<String, dynamic>> filteredArea = [];
  String _selectedZone = "";
  String _selectedField = "";
  int? fiedlId;
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredField = [];

  Future<List<Map<String, dynamic>>> getAreasbyFarmId() {
    return AreaService().getAreasActiveByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesActivebyAreaId(int areaId) {
    return ZoneService().getZonesActivebyAreaId(areaId);
  }

  Future<List<Map<String, dynamic>>> getFieldsbyZoneId(int zoneId) {
    return FieldService().getFieldsActivebyZoneId(zoneId);
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
                            dropdownStyleData: DropdownStyleData(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4),
                            isExpanded: true,
                            underline: Container(height: 0),
                            // value: _selectedArea,
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                _selectedArea = newValue!['name'];
                                _selectedField = "";
                                filteredField = [];
                              });
                              // Lọc danh sách Zone tương ứng với Area đã chọn
                              getZonesActivebyAreaId(newValue!['id'])
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
                      "Vùng (Tùy chọn)",
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
                            dropdownStyleData: DropdownStyleData(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4),
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
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vườn/Chuồng (Tùy chọn)",
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
                            dropdownStyleData: DropdownStyleData(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4),
                            isExpanded: true,
                            underline: Container(height: 0),
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                _selectedField = newValue!['nameCode'];
                                fiedlId = newValue['id'];
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
              MyInputField(
                title: "Địa chỉ chi tiết",
                hint: "Mô tả chi tiết địa chỉ",
                hintColor: kTextGreyColor,
                controller: _addressDetailController,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  GestureDetector(
                    onTap: () {
                      validate(context);
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

  validate(context) {
    if (_selectedArea != "Chọn" && _addressDetailController.text.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SecondAddTaskPage(
            addressDetail: _selectedArea +
                ", " +
                (_selectedZone.isEmpty ||
                        _selectedZone == "Chưa có" ||
                        _selectedZone == "Chọn"
                    ? ""
                    : _selectedZone + ", ") +
                (_selectedField.isEmpty ||
                        _selectedField == "Chưa có" ||
                        _selectedField == "Chọn"
                    ? ""
                    : _selectedField + ", ") +
                _addressDetailController.text.trim(),
            fieldId: null,
            otherId: null,
            liveStockId: null,
            plantId: null,
            isPlant: null,
          ),
        ),
      );
    } else {
      SnackbarShowNoti.showSnackbar("Dữ liệu không hợp lệ", true);
    }
  }
}
