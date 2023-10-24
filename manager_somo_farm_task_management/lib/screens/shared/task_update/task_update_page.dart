import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/livestock_sevice.dart';
import 'package:manager_somo_farm_task_management/services/material_service.dart';
import 'package:manager_somo_farm_task_management/services/member_service.dart';
import 'package:manager_somo_farm_task_management/services/plant_service.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
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
  List<Map<String, dynamic>> externalIds = [];
  Map<String, dynamic>? externalSelected;
  final TextEditingController _titleController = TextEditingController();
  List<Map<String, dynamic>> taskTypes = [];
  Map<String, dynamic>? taskTypeSelected;
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> employeesSelected = [];
  Key _keyChange = UniqueKey();
  Map<String, dynamic>? supervisorSelected;
  List<Map<String, dynamic>> supervisors = [];
  List<Map<String, dynamic>> materials = [];
  List<Map<String, dynamic>> materialsSelected = [];
  final TextEditingController _desController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<Map<String, dynamic>> priorities = [];
  Map<String, dynamic>? prioritySelected;
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
    widget.task['fieldStatus'] == "Động vật"
        ? ZoneService().getZonesbyAreaLivestockId(areaId).then((value) {
            setState(() {
              zones = value;
              if (init)
                zoneSelected = zones
                    .where((element) => element['id'] == widget.task['zoneId'])
                    .firstOrNull;
            });
          })
        : ZoneService().getZonesbyAreaPlantId(areaId).then((value) {
            setState(() {
              zones = value;
              if (init)
                zoneSelected = zones
                    .where((element) => element['id'] == widget.task['zoneId'])
                    .firstOrNull;
            });
          });
  }

  Future<void> getFields(int zoneId, bool init) async {
    FieldService().getFieldsActivebyZoneId(zoneId).then((value) {
      setState(() {
        fields = value;
        if (init)
          fieldSelected = fields
              .where((element) => element['id'] == widget.task['fieldId'])
              .firstOrNull;
      });
    });
  }

  Future<void> getExternalIds(int fieldId, bool init) async {
    widget.task['fieldStatus'] == "Động vật"
        ? LiveStockService()
            .getLiveStockExternalIdsByFieldId(fieldId)
            .then((value) {
            setState(() {
              externalIds = value;
              if (init)
                externalSelected = externalIds
                    .where((element) =>
                        element['externalId'] == widget.task['externalId'])
                    .firstOrNull;
            });
          })
        : PlantService().getPlantExternalIdsByFieldId(fieldId).then((value) {
            setState(() {
              externalIds = value;
              if (init)
                externalSelected = externalIds
                    .where((element) =>
                        element['externalId'] == widget.task['externalId'])
                    .firstOrNull;
            });
          });
  }

  Future<void> getTaskTypes() async {
    widget.task['fieldStatus'] == "Động vật"
        ? TaskTypeService().getListTaskTypeLivestock().then((value) {
            setState(() {
              taskTypes = value;
              taskTypeSelected = taskTypes
                  .where(
                      (element) => element['id'] == widget.task['taskTypeId'])
                  .firstOrNull;
            });
          })
        : TaskTypeService().getTaskTypePlants().then((value) {
            setState(() {
              taskTypes = value;
              taskTypeSelected = taskTypes
                  .where(
                      (element) => element['id'] == widget.task['taskTypeId'])
                  .firstOrNull;
            });
          });
  }

  Future<void> getEmployeesbyFarmIdAndTaskTypeId(
      int taskTypeId, bool init) async {
    EmployeeService()
        .getEmployeesbyFarmIdAndTaskTypeId(farmId!, taskTypeId)
        .then((value) {
      setState(() {
        employees = value;
        if (init)
          employeesSelected = employees
              .where((element) =>
                  widget.task['employeeId'].contains(element['id']))
              .toList();
      });
    });
  }

  Future<void> getSupervisors() async {
    MemberService().getSupervisorsActivebyFarmId(farmId!).then((value) {
      setState(() {
        supervisors = value;
        supervisorSelected = supervisors
            .where((element) => element['id'] == widget.task['suppervisorId'])
            .firstOrNull;
      });
    });
  }

  Future<void> getMaterials(bool init) async {
    MaterialService().getMaterialActive().then((value) {
      setState(() {
        materials = value;
        if (init)
          materialsSelected = materials
              .where((element) =>
                  widget.task['materialId'].contains(element['id']))
              .toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getFarmId().then((_) {
      getAreas();
      getZones(widget.task['areaId'], true);
      getFields(widget.task['zoneId'], true);
      if (widget.task['externalId'] != null)
        getExternalIds(widget.task['fieldId'], true);
      getTaskTypes();
      getEmployeesbyFarmIdAndTaskTypeId(widget.task['taskTypeId'], true);
      getSupervisors();
      getMaterials(true);
    });
    _titleController.text = widget.task['name'];
    _desController.text = widget.task['description'];
    _selectedStartDate = DateTime.parse((widget.task['startDate']));

    _selectedEndDate = DateTime.parse(widget.task['endDate']);
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
                            fieldSelected = null;
                            getFields(newValue['id'], false);
                            externalSelected = null;
                            getExternalIds(newValue['id'], false);
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
                            fieldSelected = null;
                            getFields(newValue!['id'], false);
                            externalSelected = null;
                            getExternalIds(newValue['id'], false);
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
                      widget.task['fieldStatus'] == "Động vật"
                          ? "Chuồng"
                          : "Vườn",
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
                            externalSelected = null;
                            getExternalIds(newValue!['id'], false);
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
                widget.task['fieldStatus'] == "Động vật"
                    ? Text(
                        "Vùng này chưa có chuồng. Hãy chọn vùng khác!",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      )
                    : Text(
                        "Vùng này chưa có Vườn. Hãy chọn vùng khác!",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      ),
              if (widget.task['externalId'] != null)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task['fieldStatus'] == "Động vật"
                            ? "Mã con vật"
                            : "Mã cây trồng",
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
                          value: externalSelected,
                          onChanged: (newValue) {
                            setState(() {
                              externalSelected = newValue;
                            });
                          },
                          items: externalIds
                              .map<DropdownMenuItem<Map<String, dynamic>>>(
                                  (Map<String, dynamic> value) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: value,
                              child: Text(value['externalId']),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              if (widget.task['externalId'] != null && externalIds.isEmpty)
                widget.task['fieldStatus'] == "Động vật"
                    ? Text(
                        "Chuồng này không có con vật nào. Hãy chọn chuồng khác!",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      )
                    : Text(
                        "Vườn này chưa có cây trồng nào. Hãy chọn vườn khác!",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      ),
              MyInputField(
                title: "Tên công việc",
                hint: "Nhập tên công việc",
                controller: _titleController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loại công việc",
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
                        value: taskTypeSelected,
                        onChanged: (newValue) {
                          setState(() {
                            taskTypeSelected = newValue;
                            employeesSelected.clear();
                            getEmployeesbyFarmIdAndTaskTypeId(
                                newValue!['id'], false);
                            _keyChange = UniqueKey();
                          });
                        },
                        items: taskTypes
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
                      "Người thực hiện",
                      style: titileStyle,
                    ),
                    Container(
                      height: 52,
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.only(left: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: ChipsInput(
                          suggestionsBoxMaxHeight: 200,
                          key: _keyChange,
                          enabled: !employeesSelected.isEmpty,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Chọn người thực hiện",
                              hintStyle: TextStyle(color: Colors.black45)),
                          initialValue: employeesSelected,
                          findSuggestions: (String query) {
                            if (query.length != 0) {
                              var lowercaseQuery =
                                  removeDiacritics(query.toLowerCase());
                              return employees.where((e) {
                                return removeDiacritics(e['name'].toLowerCase())
                                    .contains(lowercaseQuery);
                              }).toList(growable: false)
                                ..sort((a, b) =>
                                    removeDiacritics(a['name'].toLowerCase())
                                        .indexOf(lowercaseQuery)
                                        .compareTo(removeDiacritics(
                                                b['name'].toLowerCase())
                                            .indexOf(lowercaseQuery)));
                            } else {
                              return const <Map<String, dynamic>>[];
                            }
                          },
                          onChanged: (data) {
                            employeesSelected =
                                data.cast<Map<String, dynamic>>();
                          },
                          chipBuilder: (context, state, employee) {
                            return InputChip(
                              key: ObjectKey(employee),
                              label: Text(employee['name']),
                              onDeleted: () => state.deleteChip(employee),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder: (context, state, profile) {
                            return ListTile(
                              key: ObjectKey(profile),
                              title: Text(profile['name']),
                              onTap: () => state.selectSuggestion(profile),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (employees.isEmpty)
                Text(
                  "Hãy chọn loại công việc khác",
                  style: TextStyle(fontSize: 11, color: Colors.red, height: 2),
                ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Người giám sát",
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
                        value: supervisorSelected,
                        onChanged: (newValue) {
                          setState(() {
                            supervisorSelected = newValue;
                            getSupervisors();
                          });
                        },
                        items: supervisors
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
                      "Dụng cụ",
                      style: titileStyle,
                    ),
                    Container(
                      height: 52,
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.only(left: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: ChipsInput(
                          suggestionsBoxMaxHeight: 200,
                          enabled: !materialsSelected.isEmpty,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Chọn công cụ cần thiết",
                              hintStyle: TextStyle(color: Colors.black45)),
                          initialValue: materialsSelected,
                          key: GlobalKey(),
                          findSuggestions: (String query) {
                            if (query.length != 0) {
                              var lowercaseQuery =
                                  removeDiacritics(query.toLowerCase());
                              return materials.where((e) {
                                return removeDiacritics(e['name'].toLowerCase())
                                    .contains(lowercaseQuery);
                              }).toList(growable: false)
                                ..sort((a, b) =>
                                    removeDiacritics(a['name'].toLowerCase())
                                        .indexOf(lowercaseQuery)
                                        .compareTo(removeDiacritics(
                                                b['name'].toLowerCase())
                                            .indexOf(lowercaseQuery)));
                            } else {
                              return const <Map<String, dynamic>>[];
                            }
                          },
                          onChanged: (data) {
                            materialsSelected =
                                data.cast<Map<String, dynamic>>();
                          },
                          chipBuilder: (context, state, material) {
                            return InputChip(
                              key: ObjectKey(material),
                              label: Text(material['name']),
                              onDeleted: () => state.deleteChip(material),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder: (context, state, profile) {
                            return ListTile(
                              key: ObjectKey(profile),
                              title: Text(profile['name']),
                              onTap: () => state.selectSuggestion(profile),
                            );
                          },
                        ),
                      ),
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
                      "Mô tả",
                      style: titileStyle,
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        maxLines: null,
                        autofocus: false,
                        controller: _desController,
                        style: subTitileStyle,
                        decoration: InputDecoration(
                          hintText: "Nhập mô tả",
                          hintStyle:
                              subTitileStyle.copyWith(color: kTextGreyColor),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kBackgroundColor, width: 0),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kBackgroundColor, width: 0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              MyInputField(
                title: "Ngày giờ thực hiện",
                hint: _selectedStartDate == null
                    ? "dd/MM/yyyy HH:mm a"
                    : DateFormat('dd/MM/yyyy HH:mm a')
                        .format(_selectedStartDate!),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateTimeFromUser(true);
                  },
                ),
              ),
              MyInputField(
                title: "Ngày giờ kết thúc",
                hint: _selectedEndDate == null
                    ? "dd/MM/yyyy HH:mm a"
                    : DateFormat('dd/MM/yyyy HH:mm a')
                        .format(_selectedEndDate!),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateTimeFromUser(false);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Độ ưu tiên",
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
                        value: prioritySelected,
                        onChanged: (newValue) {
                          setState(() {
                            prioritySelected = newValue;
                          });
                        },
                        items: priorities
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
              SizedBox(height: 15),
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
                        "Cập nhật",
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

  _getDateTimeFromUser(bool isStart) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 36525)),
    );

    if (selectedDate != null) {
      // Nếu người dùng đã chọn một ngày, tiếp theo bạn có thể chọn giờ
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Người dùng đã chọn cả ngày và giờ
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        if (isStart == false && _selectedStartDate == null) {
          SnackbarShowNoti.showSnackbar("Chọn ngày giờ thực hiện trước", true);
        } else if (isStart == false &&
                selectedDateTime.isBefore(_selectedStartDate!) ||
            isStart == false &&
                selectedDateTime.isAtSameMomentAs(_selectedStartDate!)) {
          SnackbarShowNoti.showSnackbar(
              "Ngày giờ kết thúc phải lớn hơn ngày giờ thực hiện", true);
        } else {
          setState(() {
            if (isStart) {
              _selectedStartDate = selectedDateTime;
              _selectedEndDate = null;
              // _focusedDay = _selectedStartDate!.add(Duration(days: 1));
            } else {
              _selectedEndDate = selectedDateTime;
            }
          });
        }
      }
      return;
    }
    return;
  }
}
