import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
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

class UpdateTaskDraftTodoPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final String role;
  final bool changeTodo;
  const UpdateTaskDraftTodoPage(
      {super.key,
      required this.task,
      required this.role,
      required this.changeTodo});

  @override
  State<UpdateTaskDraftTodoPage> createState() => _UpdateTaskDraftTodoPage();
}

class _UpdateTaskDraftTodoPage extends State<UpdateTaskDraftTodoPage> {
  bool isCheck = true;
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
    widget.task['isPlant'] == null
        ? await AreaService().getAreasActiveByFarmId(farmId!).then((value) {
            setState(() {
              areas = value;
            });
          })
        : widget.task['isPlant'] == false
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
    setState(() {
      isCheck = true;
    });
    widget.task['isPlant'] == null
        ? await ZoneService().getZonesActivebyAreaId(areaId).then((value) {
            setState(() {
              zones = value;
              isCheck = false;
              if (init)
                zoneSelected = zones
                    .where((element) => element['id'] == widget.task['zoneId'])
                    .firstOrNull;
            });
          })
        : widget.task['isPlant'] == false
            ? await ZoneService()
                .getZonesbyAreaLivestockId(areaId)
                .then((value) {
                setState(() {
                  zones = value;
                  isCheck = false;
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
                  isCheck = false;
                  if (init)
                    zoneSelected = zones
                        .where(
                            (element) => element['id'] == widget.task['zoneId'])
                        .firstOrNull;
                });
              });
  }

  Future<void> getFields(int zoneId, bool init) async {
    setState(() {
      isCheck = true;
    });
    await FieldService().getFieldsActivebyZoneId(zoneId).then((value) {
      setState(() {
        fields = value;
        isCheck = false;
        if (init)
          fieldSelected = fields
              .where((element) => element['id'] == widget.task['fieldId'])
              .firstOrNull;
      });
    });
  }

  Future<void> getExternalIds(int fieldId, bool init) async {
    setState(() {
      isCheck = true;
    });
    widget.task['isPlant'] == false
        ? await LiveStockService()
            .getLiveStockExternalIdsByFieldId(fieldId)
            .then((value) {
            setState(() {
              externalIds = value;
              isCheck = false;
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
              isCheck = false;
              if (init)
                externalSelected = externalIds
                    .where((element) =>
                        element['externalId'] == widget.task['externalId'])
                    .firstOrNull;
            });
          });
  }

  Future<void> getTaskTypes() async {
    widget.task['isPlant'] == null
        ? await TaskTypeService().getTaskTypeOther().then((value) {
            setState(() {
              taskTypes = value;
              taskTypeSelected = taskTypes
                  .where(
                      (element) => element['id'] == widget.task['taskTypeId'])
                  .firstOrNull;
            });
          })
        : widget.task['isPlant'] == false
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
      if (widget.task['areaId'] != null)
        getZones(widget.task['areaId'], widget.task['zoneId'] != null);
      if (widget.task['zoneId'] != null)
        getFields(widget.task['zoneId'], widget.task['fieldId'] != null);
      if (widget.task['fieldId'] != null && widget.task['isSpecific'])
        getExternalIds(
            widget.task['fieldId'], widget.task['externalId'] != null);
    });
    await getTaskTypes();
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

  Future<bool> updateTask(Map<String, dynamic> data) async {
    return TaskService().updateTask(data, widget.task['id']);
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
    _titleController.text = widget.task['name'];
    _desController.text = widget.task['description'];
    if (widget.task['startDate'] != null) {
      _selectedStartDate = DateTime.parse((widget.task['startDate']));
    }

    if (widget.task['endDate'] != null) {
      _selectedEndDate = DateTime.parse(widget.task['endDate']);
      _focusedDay = _selectedEndDate!.add(Duration(days: 1));
    }

    prioritySelected = widget.task['priority'];
    _selectedRepeat = widget.task['isRepeat'] ? "Có" : "Không";

    List<dynamic> dateStrings = widget.task['dateRepeate'];
    selectedDatesRepeat =
        dateStrings.map((dateString) => DateTime.parse(dateString)).toList();

    _selectedRemind = widget.task['remind'];
    if (widget.task['startDate'] != null && widget.task['endDate'] != null)
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
                      widget.changeTodo
                          ? "Xác nhận thông tin"
                          : "Chỉnh sửa công việc",
                      style: headingStyle,
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
                              hint: Text("Chọn"),
                              isExpanded: true,
                              underline: Container(height: 0),
                              value: taskTypeSelected,
                              onChanged: (newValue) {
                                setState(() {
                                  taskTypeSelected = newValue;
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
                          widget.task['isPlant'] != null
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
                              hint: Text("Chọn"),
                              isExpanded: true,
                              underline: Container(height: 0),
                              value: areaSelected,
                              onChanged: (newValue) {
                                setState(() {
                                  areaSelected = newValue;
                                  zoneSelected = null;
                                  getZones(newValue!['id'], false);
                                  fieldSelected = null;
                                  externalSelected = null;
                                  if (widget.task['isPlant'] == null)
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
                          widget.task['isPlant'] != null
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
                    if (!isCheck)
                      if (widget.task['isPlant'] != null &&
                          zones.isEmpty &&
                          areaSelected != null &&
                          widget.task['status'] != "Bản nháp")
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
                          widget.task['isPlant'] != null
                              ? Text(
                                  widget.task['isPlant'] == false
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
                                  print(newValue!['id']);
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
                    if (!isCheck)
                      if (fields.isEmpty &&
                          zoneSelected != null &&
                          widget.task['isPlant'] != null &&
                          widget.task['status'] != "Bản nháp")
                        widget.task['isPlant'] == true
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
                    if (widget.task['isSpecific'] == true)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task['isPlant'] == false
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
                                hint: externalIds.isEmpty
                                    ? Text("Chưa có",
                                        style: TextStyle(fontSize: 14))
                                    : Text("Chọn",
                                        style: TextStyle(fontSize: 14)),
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
                    if (!isCheck)
                      if (widget.task['isSpecific'] == true &&
                          externalIds.isEmpty &&
                          widget.task['status'] != "Bản nháp")
                        widget.task['isPlant'] == false
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
                    if (widget.task['isPlant'] == null)
                      MyInputField(
                        title: "Địa chỉ chi tiết",
                        hint: "Nhập địa chỉ chi tiết",
                        controller: _addressDetailController,
                        hintColor: Colors.grey,
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
                              hint: Text("Chọn"),
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
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(),
                        GestureDetector(
                          onTap: () {
                            if (widget.changeTodo &&
                                widget.task['status'] == "Bản nháp")
                              validateUpdateTodo(
                                  context, widget.task['isPlant']);
                            else if (widget.task['status'] == "Bản nháp")
                              validateUpdateDraft(
                                  context, widget.task['isPlant']);
                            else
                              validateUpdateTodo(
                                  context, widget.task['isPlant']);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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

  Map<String, dynamic> createTaskData(isPlant) {
    List<String> formattedDates = selectedDatesRepeat.map((date) {
      return DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(date);
    }).toList();
    Map<String, dynamic> taskData = {
      "materialIds": listIds(materialsSelected),
      "dates": formattedDates,
      // "dates":
      "taskModel": {
        "name": _titleController.text,
        "startDate": _selectedStartDate != null
            ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedStartDate!)
            : null,
        "endDate": _selectedEndDate != null
            ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedEndDate!)
            : null,
        "description": _desController.text,
        "priority": prioritySelected,
        "isRepeat": _selectedRepeat == "Không" ? false : true,
        "supervisorId": supervisorSelected != null
            ? (widget.role == "Manager" ? supervisorSelected!['id'] : userId!)
            : null,
        "fieldId": fieldSelected != null ? fieldSelected!['id'] : null,
        "taskTypeId": taskTypeSelected != null ? taskTypeSelected!['id'] : null,
        "managerId": widget.role == "Manager" ? userId : null,
        "plantId": widget.task['isSpecific'] && widget.task['isPlant']
            ? externalSelected != null
                ? externalSelected!['id']
                : null
            : null,
        "liveStockId":
            (widget.task['isSpecific'] && widget.task['isPlant'] == false)
                ? externalSelected != null
                    ? externalSelected!['id']
                    : null
                : null,
        "addressDetail": isPlant == null
            ? (areaSelected == null ? "" : areaSelected!['name']) +
                (zoneSelected == null
                    ? ""
                    : (areaSelected == null ? "" : ", ") +
                        zoneSelected!['name']) +
                (fieldSelected == null
                    ? ""
                    : (areaSelected == null && zoneSelected == null
                            ? ""
                            : ", ") +
                        fieldSelected!['name']) +
                (_addressDetailController.text.trim().isEmpty
                    ? ""
                    : (areaSelected == null &&
                                zoneSelected == null &&
                                fieldSelected == null
                            ? ""
                            : ", ") +
                        _addressDetailController.text.trim())
            : null,
        "remind": _selectedRemind,
      }
    };
    print(taskData);
    return taskData;
  }

  validateUpdateDraft(context, isPlant) {
    setState(() {
      isLoading = true;
    });
    if (_titleController.text.isNotEmpty) {
      update(isPlant);
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(
          "Để lưu công việc bạn cần điền tên công việc", true);
    }
  }

  validateUpdateTodo(context, isPlant) {
    setState(() {
      isLoading = true;
    });

    if (isPlant == null) {
      if (_titleController.text.isNotEmpty &&
          taskTypeSelected != null &&
          _addressDetailController.text.isNotEmpty &&
          (widget.role == "Supervisor" ||
              widget.role == "Manager" && supervisorSelected != null) &&
          _selectedStartDate != null &&
          _selectedEndDate != null &&
          (_selectedRepeat!.toLowerCase() == "Có".toLowerCase() &&
                  selectedDatesRepeat.isNotEmpty ||
              _selectedRepeat!.toLowerCase() == "Không".toLowerCase())) {
        widget.changeTodo ? updateTaskandChangeTdo(isPlant) : update(isPlant);
      } else {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar(
            "Để giao việc bạn phải điền đầy đủ các dữ liệu cần thiết!", true);
      }
    } else if (fieldSelected != null &&
        (!widget.task['isSpecific'] ||
            widget.task['isSpecific'] && externalSelected != null) &&
        _titleController.text.isNotEmpty &&
        taskTypeSelected != null &&
        (widget.role == "Supervisor" ||
            widget.role == "Manager" && supervisorSelected != null) &&
        _selectedStartDate != null &&
        _selectedEndDate != null &&
        (_selectedRepeat!.toLowerCase() == "Có".toLowerCase() &&
                selectedDatesRepeat.isNotEmpty ||
            _selectedRepeat!.toLowerCase() == "Không".toLowerCase())) {
      widget.changeTodo ? updateTaskandChangeTdo(isPlant) : update(isPlant);
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(
          "Để giao việc bạn phải điền đầy đủ các dữ liệu cần thiết!", true);
    }
  }

  void update(isPlant) {
    updateTask(createTaskData(isPlant)).then((value) {
      if (value) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop("ok");
        SnackbarShowNoti.showSnackbar('Lưu công việc thành công', false);
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(e.toString(), true);
    });
  }

  void updateTaskandChangeTdo(isPlant) {
    TaskService()
        .updateTaskandChangeTodo(createTaskData(isPlant), widget.task['id'])
        .then((value) {
      if (value) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop("ok");
        SnackbarShowNoti.showSnackbar(
            'Đã chuyển công việc sang chuẩn bị', false);
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(e.toString(), true);
    });
  }
}
