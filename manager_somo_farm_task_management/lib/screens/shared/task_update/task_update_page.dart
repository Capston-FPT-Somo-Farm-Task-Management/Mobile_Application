import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/livestock_service.dart';
import 'package:manager_somo_farm_task_management/services/material_service.dart';
import 'package:manager_somo_farm_task_management/services/member_service.dart';
import 'package:manager_somo_farm_task_management/services/plant_service.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class UpdateTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final String role;
  const UpdateTaskPage({super.key, required this.task, required this.role});

  @override
  State<UpdateTaskPage> createState() => _FirstUpdateTaskPage();
}

class _FirstUpdateTaskPage extends State<UpdateTaskPage> {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  List<DateTime> disabledDates = [];
  int? rangeDate;
  int? farmId;
  bool isLoading = true;
  int? userId;
  List<Map<String, dynamic>> areas = [];
  Map<String, dynamic>? areaSelected;
  List<Map<String, dynamic>> zones = [];
  Map<String, dynamic>? zoneSelected;
  List<Map<String, dynamic>> fields = [];
  Map<String, dynamic>? fieldSelected;
  List<Map<String, dynamic>> externalIds = [];
  Map<String, dynamic>? externalSelected;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
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
  List<String> priorities = [
    "Thấp",
    "Trung bình",
    "Cao",
  ];
  String? prioritySelected;

  int? _selectedRemind;
  List<int> remindList = [0, 5, 10, 15, 20];

  String? _selectedRepeat;
  List<String> repeatList = ["Không", "Có"];
  List<DateTime> selectedDatesRepeat = [];
  DateTime _focusedDay = DateTime.now();
  String _formatDates(List<DateTime> dates) {
    if (dates.isEmpty) {
      return 'Không có ngày được chọn';
    }

    List<String> formattedDates = dates.map((date) {
      return DateFormat('dd-MM-yyyy').format(date);
    }).toList();

    return formattedDates.join(', ');
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userIdStored = prefs.getInt('userId');
    setState(() {
      userId = userIdStored;
    });
  }

  void _onDaySelected(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  Future<void> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    setState(() {
      farmId = storedFarmId;
    });
  }

  Future<void> getAreas() async {
    widget.task['areaId'] == null
        ? await AreaService().getAreasActiveByFarmId(farmId!).then((value) {
            setState(() {
              areas = value;
              if (widget.task['areaId'] != null)
                areaSelected = areas
                    .where((element) => element['id'] == widget.task['areaId'])
                    .firstOrNull;
            });
          })
        : widget.task['fieldStatus'] == "Động vật"
            ? await AreaService()
                .getAreasActiveZoneLiveStockByFarmId(farmId!)
                .then((value) {
                setState(() {
                  areas = value;
                  if (widget.task['areaId'] != null)
                    areaSelected = areas
                        .where(
                            (element) => element['id'] == widget.task['areaId'])
                        .firstOrNull;
                });
              })
            : await AreaService()
                .getAreasActiveZonePlantByFarmId(farmId!)
                .then((value) {
                setState(() {
                  areas = value;
                  if (widget.task['areaId'] != null)
                    areaSelected = areas
                        .where(
                            (element) => element['id'] == widget.task['areaId'])
                        .firstOrNull;
                });
              });
  }

  Future<void> getZones(int areaId, bool init) async {
    widget.task['areaId'] == null
        ? await ZoneService().getZonesActivebyAreaId(areaId).then((value) {
            setState(() {
              zones = value;
              if (init)
                zoneSelected = zones
                    .where((element) => element['id'] == widget.task['zoneId'])
                    .firstOrNull;
            });
          })
        : widget.task['fieldStatus'] == "Động vật"
            ? await ZoneService()
                .getZonesbyAreaLivestockId(areaId)
                .then((value) {
                setState(() {
                  zones = value;
                  if (init)
                    zoneSelected = zones
                        .where(
                            (element) => element['id'] == widget.task['zoneId'])
                        .firstOrNull;
                });
              })
            : await ZoneService().getZonesbyAreaPlantId(areaId).then((value) {
                setState(() {
                  zones = value;
                  if (init)
                    zoneSelected = zones
                        .where(
                            (element) => element['id'] == widget.task['zoneId'])
                        .firstOrNull;
                });
              });
  }

  Future<void> getFields(int zoneId, bool init) async {
    await FieldService().getFieldsActivebyZoneId(zoneId).then((value) {
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
        ? await LiveStockService()
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
        : await PlantService()
            .getPlantExternalIdsByFieldId(fieldId)
            .then((value) {
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
    widget.task['areaId'] == null
        ? await TaskTypeService().getTaskTypeOther().then((value) {
            setState(() {
              taskTypes = value;
              taskTypeSelected = taskTypes
                  .where(
                      (element) => element['id'] == widget.task['taskTypeId'])
                  .firstOrNull;
            });
          })
        : widget.task['fieldStatus'] == "Động vật"
            ? await TaskTypeService().getListTaskTypeLivestock().then((value) {
                setState(() {
                  taskTypes = value;
                  taskTypeSelected = taskTypes
                      .where((element) =>
                          element['id'] == widget.task['taskTypeId'])
                      .firstOrNull;
                });
              })
            : await TaskTypeService().getTaskTypePlants().then((value) {
                setState(() {
                  taskTypes = value;
                  taskTypeSelected = taskTypes
                      .where((element) =>
                          element['id'] == widget.task['taskTypeId'])
                      .firstOrNull;
                });
              });
  }

  Future<void> getEmployeesbyFarmIdAndTaskTypeId(
      int taskTypeId, bool init) async {
    await EmployeeService()
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
    await MemberService().getSupervisorsActivebyFarmId(farmId!).then((value) {
      setState(() {
        supervisors = value;
        supervisorSelected = supervisors
            .where((element) => element['id'] == widget.task['suppervisorId'])
            .firstOrNull;
      });
    });
  }

  Future<void> getMaterials(bool init) async {
    await MaterialService().getMaterialActiveByFamrId(farmId!).then((value) {
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

  List<int> listIds(List<Map<String, dynamic>> listObject) {
    List<int> ids = [];
    for (var o in listObject) {
      if (o.containsKey('id') && o['id'] is int) {
        ids.add(o['id']);
      }
    }
    return ids;
  }

  Future<void> initData() async {
    await getFarmId().then((_) {
      getAreas();
      if (widget.task['areaId'] != null) {
        getZones(widget.task['areaId'], true);
        getFields(widget.task['zoneId'], true);
        if (widget.task['externalId'] != null)
          getExternalIds(widget.task['fieldId'], true);
      }
    });
    await getTaskTypes();
    await getEmployeesbyFarmIdAndTaskTypeId(widget.task['taskTypeId'], true);
    await getSupervisors();
    await getMaterials(true);
  }

  void calculateDateDifference(DateTime startDate, DateTime endDate) {
    setState(() {
      rangeDate = endDate.difference(startDate).inDays;
    });
  }

  void getDisabledDates() {
    for (DateTime selectedDate in selectedDatesRepeat) {
      for (int i = 1; i <= rangeDate!; i++) {
        DateTime newDateAdd = selectedDate.add(Duration(days: i));
        DateTime newDateMinus = selectedDate.subtract(Duration(days: i));
        DateTime newDateAddWithoutTime =
            DateTime(newDateAdd.year, newDateAdd.month, newDateAdd.day);
        DateTime newDateMinusWithoutTime =
            DateTime(newDateMinus.year, newDateMinus.month, newDateMinus.day);
        setState(() {
          disabledDates.add(newDateAddWithoutTime);
          disabledDates.add(newDateMinusWithoutTime);
        });
      }
    }
  }

  void addDisabledDates(DateTime date) {
    for (int i = 1; i <= rangeDate!; i++) {
      DateTime newDateAdd = date.add(Duration(days: i));
      DateTime newDateMinus = date.subtract(Duration(days: i));
      DateTime newDateAddWithoutTime =
          DateTime(newDateAdd.year, newDateAdd.month, newDateAdd.day);
      DateTime newDateMinusWithoutTime =
          DateTime(newDateMinus.year, newDateMinus.month, newDateMinus.day);
      setState(() {
        disabledDates.add(newDateAddWithoutTime);
        disabledDates.add(newDateMinusWithoutTime);
      });
    }
  }

  void removeDisabledDates(DateTime date) {
    for (int i = 1; i <= rangeDate!; i++) {
      DateTime newDateAdd = date.add(Duration(days: i));
      DateTime newDateMinus = date.subtract(Duration(days: i));
      DateTime newDateAddWithoutTime =
          DateTime(newDateAdd.year, newDateAdd.month, newDateAdd.day);
      DateTime newDateMinusWithoutTime =
          DateTime(newDateMinus.year, newDateMinus.month, newDateMinus.day);

      setState(() {
        disabledDates.remove(newDateAddWithoutTime);
        disabledDates.remove(newDateMinusWithoutTime);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    initData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    if (widget.task['addressDetail'] != null)
      _addressDetailController.text = widget.task['addressDetail'];
    _minutesController.text = widget.task['overallEfforMinutes'].toString();
    _hoursController.text = widget.task['overallEffortHour'].toString();
    _titleController.text = widget.task['name'];
    _desController.text = widget.task['description'];
    _selectedStartDate = DateTime.parse((widget.task['startDate']));

    _selectedEndDate = DateTime.parse(widget.task['endDate']);
    prioritySelected = widget.task['priority'];
    _selectedRepeat = widget.task['isRepeat'] ? "Có" : "Không";
    _focusedDay = _selectedEndDate!.add(Duration(days: 1));
    List<dynamic> dateStrings = widget.task['dateRepeate'];
    selectedDatesRepeat =
        dateStrings.map((dateString) => DateTime.parse(dateString)).toList();

    _selectedRemind = widget.task['remind'];

    calculateDateDifference(DateTime.parse(widget.task['startDate']),
        DateTime.parse(widget.task['endDate']));

    getDisabledDates();
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : Container(
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
                          widget.task['areaId'] != null
                              ? Text(
                                  "Khu vực",
                                  style: titileStyle,
                                )
                              : Text(
                                  "Khu vực (tùy chọn)",
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
                                  if (widget.task['areaId'] == null)
                                    _addressDetailController.text = "";
                                });
                              },
                              items: areas
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
                          widget.task['areaId'] != null
                              ? Text(
                                  "Vùng",
                                  style: titileStyle,
                                )
                              : Text(
                                  "Vùng (tùy chọn)",
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
                              hint: zones.isEmpty
                                  ? Text(
                                      "Chưa có",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : Text("Chọn",
                                      style: TextStyle(fontSize: 14)),
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
                                  child: Text(value['nameCode']),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (zones.isEmpty &&
                        areaSelected != null &&
                        widget.task['areaId'] != null)
                      Text(
                        "Khu vực chưa có vùng. Hãy chọn khu vực khác!",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.task['areaId'] != null
                              ? Text(
                                  widget.task['fieldStatus'] == "Động vật"
                                      ? "Chuồng"
                                      : "Vườn",
                                  style: titileStyle,
                                )
                              : Text("Vườn/Chuồng (tùy chọn)"),
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
                              hint: fields.isEmpty
                                  ? Text("Chưa có",
                                      style: TextStyle(fontSize: 14))
                                  : Text("Chọn",
                                      style: TextStyle(fontSize: 14)),
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
                                  child: Text(value['nameCode']),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (fields.isEmpty &&
                        zoneSelected != null &&
                        widget.task['areaId'] != null)
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
                                items: externalIds.map<
                                        DropdownMenuItem<Map<String, dynamic>>>(
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
                    if (widget.task['externalId'] != null &&
                        externalIds.isEmpty)
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
                    if (widget.task['addressDetail'] != null)
                      MyInputField(
                        title: "Địa chỉ chi tiết",
                        hint: "Nhập địa chỉ chi tiết",
                        controller: _addressDetailController,
                        hintColor: Colors.grey,
                      ),
                    MyInputField(
                      title: "Tên công việc",
                      hint: "Nhập tên công việc",
                      controller: _titleController,
                      hintColor: Colors.grey,
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
                                enabled: !employees.isEmpty,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Chọn người thực hiện",
                                    hintStyle:
                                        TextStyle(color: Colors.black45)),
                                initialValue: employeesSelected,
                                findSuggestions: (String query) {
                                  if (query.length != 0) {
                                    var lowercaseQuery =
                                        removeDiacritics(query.toLowerCase());
                                    return employees.where((e) {
                                      return removeDiacritics(
                                              e['nameCode'].toLowerCase())
                                          .contains(lowercaseQuery);
                                    }).toList(growable: false)
                                      ..sort((a, b) => removeDiacritics(
                                              a['nameCode'].toLowerCase())
                                          .indexOf(lowercaseQuery)
                                          .compareTo(removeDiacritics(
                                                  b['nameCode'].toLowerCase())
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
                                    label: Text(employee['nameCode']),
                                    onDeleted: () => state.deleteChip(employee),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  );
                                },
                                suggestionBuilder: (context, state, profile) {
                                  return ListTile(
                                    key: ObjectKey(profile),
                                    title: Text(profile['nameCode']),
                                    onTap: () =>
                                        state.selectSuggestion(profile),
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
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
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
                            "Dụng cụ (tùy chọn)",
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
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Chọn công cụ cần thiết",
                                    hintStyle:
                                        TextStyle(color: Colors.black45)),
                                initialValue: materialsSelected,
                                key: GlobalKey(),
                                findSuggestions: (String query) {
                                  if (query.length != 0) {
                                    var lowercaseQuery =
                                        removeDiacritics(query.toLowerCase());
                                    return materials.where((e) {
                                      return removeDiacritics(
                                              e['name'].toLowerCase())
                                          .contains(lowercaseQuery);
                                    }).toList(growable: false)
                                      ..sort((a, b) => removeDiacritics(
                                              a['name'].toLowerCase())
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
                                    onTap: () =>
                                        state.selectSuggestion(profile),
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
                            "Mô tả (tùy chọn)",
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
                                hintStyle: subTitileStyle.copyWith(
                                    color: kTextGreyColor),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackgroundColor, width: 0),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackgroundColor, width: 0),
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
                          widget.task['status'] == "Đang thực hiện" ||
                                  _selectedStartDate!.isBefore(DateTime.now())
                              ? null
                              : _getDateTimeFromUser(true);
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
                            "Lặp lại",
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
                                child: DropdownButton2(
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  value: _selectedRepeat,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedRepeat = newValue!;
                                      if (_selectedRepeat == "Không") {
                                        selectedDatesRepeat.clear();
                                      }
                                    });
                                  },
                                  items: repeatList
                                      .map<DropdownMenuItem<String>>(
                                          (String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value!,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_selectedRepeat != "Không")
                      _selectedStartDate == null || _selectedEndDate == null
                          ? Text(
                              "Hãy chọn ngày giờ bắt đầu và kết thúc trước!",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.red, height: 2),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    "Chọn ngày lặp lại",
                                    style: titileStyle,
                                  ),
                                ),
                                TableCalendar(
                                    locale: 'vi_VN',
                                    rowHeight: 43,
                                    headerStyle: HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true,
                                    ),
                                    availableGestures: AvailableGestures.all,
                                    firstDay: _selectedEndDate!
                                        .add(Duration(days: 1)),
                                    focusedDay: _focusedDay,
                                    lastDay:
                                        DateTime.now().add(Duration(days: 365)),
                                    onDaySelected: (date, events) {
                                      _onDaySelected(date);
                                      setState(() {
                                        if (selectedDatesRepeat.any(
                                            (selectedDate) => isSameDay(
                                                selectedDate, date))) {
                                          // Nếu ngày đã có trong danh sách, loại bỏ nó
                                          selectedDatesRepeat.removeWhere(
                                              (selectedDate) => isSameDay(
                                                  selectedDate, date));
                                          removeDisabledDates(date);
                                        } else {
                                          // Nếu ngày chưa có trong danh sách, thêm vào
                                          selectedDatesRepeat.add(date);
                                          addDisabledDates(date);
                                        }
                                      });
                                    },
                                    calendarStyle: CalendarStyle(
                                      selectedDecoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    selectedDayPredicate: (day) =>
                                        selectedDatesRepeat.any(
                                            (date) => isSameDay(date, day)),
                                    enabledDayPredicate: (DateTime day) {
                                      DateTime dayWithoutTime = DateTime(
                                          day.year, day.month, day.day);
                                      var r = !disabledDates
                                          .contains(dayWithoutTime);
                                      return r;
                                    }),
                                SizedBox(height: 20),
                                RichText(
                                  text: TextSpan(
                                    style: titileStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Ngày được chọn: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      TextSpan(
                                        text:
                                            '${_formatDates(selectedDatesRepeat)}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nhắc nhở",
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
                                child: DropdownButton2(
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedRemind = int.parse(newValue!);
                                    });
                                  },
                                  items: remindList
                                      .map<DropdownMenuItem<String>>(
                                          (int value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(value == 0
                                          ? "Không"
                                          : "${value.toString()} phút trước khi bắt đầu"),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  top: 17,
                                  left: 16,
                                  child: Text(_selectedRemind == 0
                                      ? "Không"
                                      : "$_selectedRemind phút trước khi bắt đầu"))
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
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              underline: Container(height: 0),
                              value: prioritySelected,
                              onChanged: (newValue) {
                                setState(() {
                                  prioritySelected = newValue;
                                });
                              },
                              items: priorities.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
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
                            "Thời gian làm việc dự kiến phải bỏ ra",
                            style: titileStyle,
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: TextField(
                                            textAlign: TextAlign.right,
                                            controller: _hoursController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("Giờ")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: TextField(
                                            textAlign: TextAlign.right,
                                            controller: _minutesController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "0",
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("Phút")
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                          onTap: () {
                            _validateDate();
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
              if (selectedDateTime.isBefore(DateTime.now())) {
                SnackbarShowNoti.showSnackbar(
                    "Ngày giờ thực hiện phải lớn hơn giờ hiện tại", true);
              } else {
                _selectedStartDate = selectedDateTime;

                if (_selectedEndDate != null) {
                  if (_selectedStartDate!.isAfter(_selectedEndDate!))
                    _selectedEndDate = null;
                  else {
                    calculateDateDifference(
                        _selectedStartDate!, _selectedEndDate!);
                  }
                }
                selectedDatesRepeat.clear();
                disabledDates.clear();
              }
            } else {
              _selectedEndDate = selectedDateTime;
              _focusedDay = _selectedEndDate!.add(Duration(days: 1));
              if (_selectedStartDate != null) {
                calculateDateDifference(_selectedStartDate!, _selectedEndDate!);
              }
              selectedDatesRepeat.clear();
              disabledDates.clear();
            }
          });
        }
      }
      return;
    }
    return;
  }

  _validateDate() {
    setState(() {
      isLoading = true;
    });
    if (widget.task['areaId'] != null) {
      if (_selectedStartDate != null &&
          _selectedEndDate != null &&
          employeesSelected.isNotEmpty &&
          _titleController.text.trim().isNotEmpty &&
          fieldSelected!.isNotEmpty &&
          areaSelected!.isNotEmpty &&
          zoneSelected!.isNotEmpty &&
          taskTypeSelected!.isNotEmpty &&
          _selectedRemind != null &&
          (_hoursController.text.isNotEmpty ||
              _minutesController.text.isNotEmpty)) {
        if (_selectedRepeat != "Không" && selectedDatesRepeat.isEmpty ||
            widget.role == "Manager" && supervisorSelected == null ||
            widget.task['externalId'] != null && externalSelected!.isEmpty) {
          setState(() {
            isLoading = false;
          });
          SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
        } else {
          List<String> formattedDates = selectedDatesRepeat.map((date) {
            return DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(date);
          }).toList();
//add database
          Map<String, dynamic> taskData = {
            "employeeIds": listIds(employeesSelected),
            "materialIds": listIds(materialsSelected),
            "dates": formattedDates,
            // "dates":
            "farmTask": {
              "name": _titleController.text,
              "startDate": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                  .format(_selectedStartDate!),
              "endDate": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                  .format(_selectedEndDate!),
              "description": _desController.text,
              "priority": prioritySelected,
              "isRepeat": _selectedRepeat == "Không" ? false : true,
              "suppervisorId":
                  widget.role == "Manager" ? supervisorSelected!['id'] : userId,
              "fieldId": fieldSelected!['id'],
              "taskTypeId": taskTypeSelected!['id'],
              "managerId": widget.role == "Manager" ? userId : null,
              "otherId": null,
              "plantId": widget.task['plantId'] == null
                  ? null
                  : externalSelected!['id'],
              "liveStockId": widget.task['liveStockId'] == null
                  ? null
                  : externalSelected!['id'],
              "addressDetail": _addressDetailController.text,
              "overallEfforMinutes": _minutesController.text,
              "overallEffortHour": _hoursController.text,
            }
          };
          print(taskData);
          print(userId!);
          TaskService().updateTask(taskData, widget.task['id']).then((value) {
            if (value) {
              Navigator.of(context).pop("ok");
              setState(() {
                isLoading = false;
              });
              SnackbarShowNoti.showSnackbar(
                  'Cập nhật công việc thành công', false);
            }
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
            SnackbarShowNoti.showSnackbar(e.toString(), true);
          });
        }
      }
      // else if (_selectedRepeat != "Không" && selectedDatesRepeat.isNotEmpty) {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop("ok");
      //   SnackbarShowNoti.showSnackbar('Cập nhật công việc thành công111', false);
      //}
      else {
        setState(() {
          isLoading = false;
        });
        // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
        SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
      }
    } else {
      if (_selectedStartDate != null &&
          _selectedEndDate != null &&
          employeesSelected.isNotEmpty &&
          _titleController.text.trim().isNotEmpty &&
          taskTypeSelected!.isNotEmpty &&
          _selectedRemind != null &&
          (_hoursController.text.isNotEmpty ||
              _minutesController.text.isNotEmpty) &&
          _addressDetailController.text.isNotEmpty) {
        if (_selectedRepeat != "Không" && selectedDatesRepeat.isEmpty ||
            widget.role == "Manager" && supervisorSelected == null ||
            widget.task['externalId'] != null && externalSelected!.isEmpty) {
          setState(() {
            isLoading = false;
          });
          SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
        } else {
          List<String> formattedDates = selectedDatesRepeat.map((date) {
            return DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(date);
          }).toList();
//add database
          Map<String, dynamic> taskData = {
            "employeeIds": listIds(employeesSelected),
            "materialIds": listIds(materialsSelected),
            "dates": formattedDates,
            // "dates":
            "farmTask": {
              "name": _titleController.text.trim(),
              "startDate": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                  .format(_selectedStartDate!),
              "endDate": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                  .format(_selectedEndDate!),
              "description": _desController.text,
              "priority": prioritySelected,
              "isRepeat": _selectedRepeat == "Không" ? false : true,
              "suppervisorId":
                  widget.role == "Manager" ? supervisorSelected!['id'] : userId,
              "fieldId": null,
              "taskTypeId": taskTypeSelected!['id'],
              "managerId": widget.role == "Manager" ? userId : null,
              "otherId": null,
              "plantId": widget.task['plantId'] == null
                  ? null
                  : externalSelected!['id'],
              "liveStockId": widget.task['liveStockId'] == null
                  ? null
                  : externalSelected!['id'],
              "addressDetail": (areaSelected == null
                      ? ""
                      : areaSelected!['name'] + ", ") +
                  (zoneSelected == null ? "" : zoneSelected!['name'] + ", ") +
                  (fieldSelected == null ? "" : fieldSelected!['name'] + ", ") +
                  _addressDetailController.text.trim(),
              "overallEfforMinutes": _minutesController.text,
              "overallEffortHour": _hoursController.text,
            }
          };
          print(taskData);
          print(userId!);
          TaskService().updateTask(taskData, widget.task['id']).then((value) {
            if (value) {
              Navigator.of(context).pop("ok");
              setState(() {
                isLoading = false;
              });
              SnackbarShowNoti.showSnackbar(
                  'Cập nhật công việc thành công', false);
            }
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
            SnackbarShowNoti.showSnackbar(e.toString(), true);
          });
        }
      }
      // else if (_selectedRepeat != "Không" && selectedDatesRepeat.isNotEmpty) {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop("ok");
      //   SnackbarShowNoti.showSnackbar('Cập nhật công việc thành công111', false);
      //}
      else {
        setState(() {
          isLoading = false;
        });
        // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
        SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
      }
    }
  }
}
