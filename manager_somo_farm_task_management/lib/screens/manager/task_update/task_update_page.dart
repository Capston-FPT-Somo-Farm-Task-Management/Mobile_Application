import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;
  const UpdateTaskPage({super.key, required this.task});

  @override
  State<UpdateTaskPage> createState() => _FirstUpdateTaskPage();
}

class _FirstUpdateTaskPage extends State<UpdateTaskPage> {
  int? farmId;
  List<Map<String, dynamic>> areas = [];
  Map<String, dynamic>? areaSelected;
  List<Map<String, dynamic>> zones = [];
  Map<String, dynamic>? zoneSelected;
  List<Map<String, dynamic>> fields = [];
  Map<String, dynamic>? fieldSelected;
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
        areas = value;
        areaSelected = areas
            .where((element) => element['id'] == widget.task['areaId'])
            .firstOrNull;
      });
    });
  }

  Future<void> getZones(int areaId, bool init) async {
    ZoneService().getZonesActivebyAreaId(areaId).then((value) {
      setState(() {
        zones = value;
        if (init)
          zoneSelected = zones
              .where((element) => element['id'] == widget.task['zoneId'])
              .firstOrNull;
      });
    });
  }

  Future<void> getFields(int areaId, bool init) async {
    ZoneService().getZonesActivebyAreaId(areaId).then((value) {
      setState(() {
        zones = value;
        if (init)
          zoneSelected = zones
              .where((element) => element['id'] == widget.task['zoneId'])
              .firstOrNull;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getFarmId().then((_) {
      getAreas().then((_) {
        getZones(widget.task['areaId'], true);
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
                "Chỉnh sửa công việc",
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
                        value: areaSelected,
                        onChanged: (newValue) {
                          setState(() {
                            areaSelected = newValue;
                            zoneSelected = null;
                            getZones(newValue!['id'], false);
                          });
                        },
                        items: areas
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
                        value: zoneSelected,
                        onChanged: (newValue) {
                          setState(() {
                            zoneSelected = newValue;
                          });
                        },
                        items: zones
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
              if (zones.isEmpty)
                Text(
                  "Khu vực chưa có vùng. Hãy chọn khu vực khác!",
                  style: TextStyle(fontSize: 11, color: Colors.red, height: 2),
                ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chuồng/ Vườn",
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
                        value: fieldSelected,
                        onChanged: (newValue) {
                          setState(() {
                            fieldSelected = newValue;
                          });
                        },
                        items: fields
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
              if (fields.isEmpty)
                Text(
                  "Vùng này chưa có chuồng/vườn. Hãy chọn vùng khác!",
                  style: TextStyle(fontSize: 11, color: Colors.red, height: 2),
                ),
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
