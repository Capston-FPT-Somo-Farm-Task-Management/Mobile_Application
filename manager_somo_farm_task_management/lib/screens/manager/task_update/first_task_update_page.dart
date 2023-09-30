import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/area.dart';
import 'package:manager_somo_farm_task_management/models/field.dart';
import 'package:manager_somo_farm_task_management/models/task.dart';
import 'package:manager_somo_farm_task_management/models/zone.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/second_add_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/componets/input_field.dart';

class FirstUpdateTaskPage extends StatefulWidget {
  final int farmId;
  final bool isOne;
  final bool isPlant;
  final Task task;
  const FirstUpdateTaskPage(
      {super.key,
      required this.farmId,
      required this.isOne,
      required this.isPlant,
      required this.task});

  @override
  State<FirstUpdateTaskPage> createState() => _FirstUpdateTaskPage();
}

class _FirstUpdateTaskPage extends State<FirstUpdateTaskPage> {
  String _selectedArea = areas[0].areaName;
  List<Area> filteredArea = [];
  String _selectedZone = zones[0].zoneName;
  String _selectedField = fields[0].fieldName;
  List<Zone> filteredZone =
      zones.where((zone) => zone.areaId == areas[0].areaId).toList();
  List<Field> filteredField =
      fields.where((f) => f.zoneId == zones[0].zoneId).toList();

  @override
  void initState() {
    super.initState();
    filteredArea = areas.where((a) => a.farmId == widget.farmId).toList();
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
                  onChanged: (Area? newValue) {
                    setState(() {
                      _selectedArea = newValue!.areaName;

                      // Lọc danh sách Zone tương ứng với Area đã chọn
                      filteredZone = zones
                          .where((zone) => zone.areaId == newValue.areaId)
                          .toList();

                      // Gọi setState để cập nhật danh sách zone
                      _selectedZone = filteredZone[0].zoneName;
                    });
                  },
                  items: filteredArea.map<DropdownMenuItem<Area>>((Area value) {
                    return DropdownMenuItem<Area>(
                      value: value,
                      child: Text(value.areaName),
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
                  onChanged: (Zone? newValue) {
                    setState(() {
                      _selectedZone = newValue!.zoneName;

                      // Lọc danh sách Filed tương ứng với Zone đã chọn
                      filteredField = fields
                          .where((f) => f.zoneId == newValue.zoneId)
                          .toList();

                      // Gọi setState để cập nhật danh sách zone
                      _selectedField = filteredField[0].fieldName;
                    });
                  },
                  items: filteredZone.map<DropdownMenuItem<Zone>>((Zone value) {
                    return DropdownMenuItem<Zone>(
                      value: value,
                      child: Text(value.zoneName),
                    );
                  }).toList(),
                ),
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
                  onChanged: (Field? newValue) {
                    setState(() {
                      _selectedField = newValue!.fieldName;
                    });
                  },
                  items:
                      filteredField.map<DropdownMenuItem<Field>>((Field value) {
                    return DropdownMenuItem<Field>(
                      value: value,
                      child: Text(value.fieldName),
                    );
                  }).toList(),
                ),
              ),
              if (widget.isOne)
                MyInputField(
                  title: widget.isPlant ? "Id cây trồng" : "Id con vật",
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
                    onChanged: (Field? newValue) {
                      setState(() {
                        _selectedField = newValue!.fieldName;
                      });
                    },
                    items: filteredField
                        .map<DropdownMenuItem<Field>>((Field value) {
                      return DropdownMenuItem<Field>(
                        value: value,
                        child: Text(value.fieldName),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context) => const SecondAddTaskPage(),
                    //     ),
                    //   );
                    // },
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
}
