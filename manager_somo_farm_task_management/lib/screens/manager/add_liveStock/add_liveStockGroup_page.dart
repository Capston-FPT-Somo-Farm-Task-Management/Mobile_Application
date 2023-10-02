import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestock_page.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';

import '../../../componets/input_field.dart';
import '../../../componets/input_number.dart';

class CreateLiveStockGroup extends StatefulWidget {
  final int farmId;
  const CreateLiveStockGroup({super.key, required this.farmId});

  @override
  CreateLiveStockGroupState createState() => CreateLiveStockGroupState();
}

class CreateLiveStockGroupState extends State<CreateLiveStockGroup> {
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  List<String> liveStockType = ["Bò", "Heo", "Gà", "Vịt"];
  String _selectedCrop = "Bò";

  List<Map<String, dynamic>> filteredArea = [];
  List<Map<String, dynamic>> filteredZone = [];
  String _selectedArea = "";
  String _selectedZone = "";

  Future<List<Map<String, dynamic>>> getAreasbyFarmId() {
    return AreaService().getAreasByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaId(int areaId) {
    return ZoneService().getZonesbyAreaId(areaId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaLivestockId(int areaId) {
    return ZoneService().getZonesbyAreaLivestockId(areaId);
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
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm chuồng cho vật nuôi",
                style: headingStyle,
              ),
              MyInputField(
                title: "Tên chuồng",
                hint: "Nhập tên chuồng",
                controller: _titleNameController,
              ),
              MyInputField(
                title: "Loại vật nuôi",
                hint: _selectedCrop,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCrop = newValue!;
                    });
                  },
                  items: liveStockType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              MyInputNumber(
                title: "Số lượng con vật trong chuồng",
                hint: "Nhập số lượng",
                controller: _noteController,
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
                    getZonesbyAreaLivestockId(newValue!['id']).then((value) {
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
                    });
                    // Lọc danh sách Filed tương ứng với Zone đã chọn
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
                      "Tạo chuồng",
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
    if (_titleNameController.text.isNotEmpty &&
        _noteController.text.isNotEmpty &&
        _selectedArea != "Chọn" &&
        _selectedZone != "Chọn" &&
        _selectedZone != "Chưa có") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LiveStockPage(),
        ),
      );
    } else {
      SnackbarShowNoti.showSnackbar(
          context, 'Vui lòng điền đầy đủ thông tin của vật nuôi', true);
    }
  }
}