import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/task_page.dart';
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
import 'package:manager_somo_farm_task_management/widgets/bottom_navigation_bar.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:table_calendar/table_calendar.dart';

class AddTaskPage extends StatefulWidget {
  final int farmId;
  final bool isOne;
  final bool? isPlant;
  const AddTaskPage({
    super.key,
    required this.farmId,
    required this.isOne,
    this.isPlant,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPage();
}

class _AddTaskPage extends State<AddTaskPage> {
  final TextEditingController _addressDetailController =
      TextEditingController();
  String _selectedArea = "";
  List<Map<String, dynamic>> filteredArea = [];
  String _selectedZone = "";
  String _selectedField = "";
  String _selectedExternalId = "";
  int? fiedlId;
  int? plantId;
  int? liveStockId;
  List<Map<String, dynamic>> filteredZone = [];
  List<Map<String, dynamic>> filteredField = [];
  List<Map<String, dynamic>> filteredExternalId = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  String _selectedTaskType = "";
  int? _selectedTaskTypeId;
  List<Map<String, dynamic>> selectedMaterials = [];
  List<Map<String, dynamic>> materials = [];
  List<Map<String, dynamic>> supervisors = [];
  String _selectedSupervisor = "Chọn";
  int? _selectedSupervisorId;
  List<Map<String, dynamic>> taskTypes = [];
  String? role;
  int? userId;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = "Không";
  List<String> repeatList = ["Không", "Có"];
  String showInputFieldRepeat = "Không";
  List<int> repeatNumbers = [];
  List<DateTime> selectedDatesRepeat = [];
  List<String> priorities = [
    "Thấp",
    "Trung bình",
    "Cao",
  ];
  String _selectedPriority = "Thấp";
  bool isLoading = true;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> disabledDates = [];
  int? rangeDate;
  Future<List<Map<String, dynamic>>> getAreasbyFarmId() {
    return AreaService().getAreasActiveByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesActivebyAreaId(int areaId) {
    return ZoneService().getZonesActivebyAreaId(areaId);
  }

  Future<List<Map<String, dynamic>>> getAreasActiveZoneLiveStockByFarmId() {
    return AreaService().getAreasActiveZoneLiveStockByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getAreasActiveZonePlantByFarmId() {
    return AreaService().getAreasActiveZonePlantByFarmId(widget.farmId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaPlantId(int areaId) {
    return ZoneService().getZonesbyAreaPlantId(areaId);
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaLivestockId(int areaId) {
    return ZoneService().getZonesbyAreaLivestockId(areaId);
  }

  Future<List<Map<String, dynamic>>> getFieldsbyZoneId(int zoneId) {
    return FieldService().getFieldsActivebyZoneId(zoneId);
  }

  Future<List<Map<String, dynamic>>> getPlantExternalIdsbyFieldId(int fieldId) {
    return PlantService().getPlantExternalIdsByFieldId(fieldId);
  }

  Future<List<Map<String, dynamic>>> getLiveStockExternalIdsbyFieldId(
      int fieldId) {
    return LiveStockService().getLiveStockExternalIdsByFieldId(fieldId);
  }

  Future<List<Map<String, dynamic>>> getListTaskTypeLivestocks() {
    return TaskTypeService().getListTaskTypeLivestock();
  }

  Future<List<Map<String, dynamic>>> getListTaskTypePlants() {
    return TaskTypeService().getTaskTypePlants();
  }

  Future<List<Map<String, dynamic>>> getTaskTypeOther() {
    return TaskTypeService().getTaskTypeOther();
  }

  Future<List<Map<String, dynamic>>> getEmployeesbyFarmIdAndTaskTypeId(
      int farmId, int taskTypeId) {
    return EmployeeService()
        .getEmployeesbyFarmIdAndTaskTypeId(farmId, taskTypeId);
  }

  Future<List<Map<String, dynamic>>> getSupervisorsbyFarmId(int farmId) {
    return MemberService().getSupervisorsActivebyFarmId(farmId);
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');

    setState(() {
      userId = storedUserId;
    });
  }

  Future<bool> createTaskDraft(Map<String, dynamic> taskData) {
    return TaskService().createTaskDraft(taskData);
  }

  Future<bool> createTaskTodo(Map<String, dynamic> taskData) {
    return TaskService().createTaskTodo(taskData);
  }

  Future<void> initData() async {
    widget.isPlant == null
        ? await getAreasbyFarmId().then((a) {
            setState(() {
              filteredArea = a;
              _selectedArea = "Chọn";
            });
          })
        : widget.isPlant == true
            ? getAreasActiveZonePlantByFarmId().then((a) {
                setState(() {
                  filteredArea = a;
                  _selectedArea = "Chọn";
                });
              })
            : getAreasActiveZoneLiveStockByFarmId().then((a) {
                setState(() {
                  filteredArea = a;
                  _selectedArea = "Chọn";
                });
              });

    getUserId();
    getRole();

    await getSupervisorsbyFarmId(widget.farmId).then((s) {
      setState(() {
        supervisors = s;
      });
    });
    await MaterialService()
        .getMaterialActiveByFamrId(widget.farmId)
        .then((value) {
      setState(() {
        materials = value;
      });
    });

    widget.isPlant == null
        ? getTaskTypeOther().then((value) {
            setState(() {
              taskTypes = value;
            });
          })
        : widget.isPlant == true
            ? getListTaskTypePlants().then((value) {
                setState(() {
                  taskTypes = value;
                });
              })
            : getListTaskTypeLivestocks().then((value) {
                setState(() {
                  taskTypes = value;
                });
              });
    _selectedTaskType = "Chọn";
  }

  @override
  void initState() {
    super.initState();
    initData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  String _formatDates(List<DateTime> dates) {
    if (dates.isEmpty) {
      return 'Không có ngày được chọn';
    }

    List<String> formattedDates = dates.map((date) {
      return DateFormat('dd-MM-yyyy').format(date);
    }).toList();

    return formattedDates.join(', ');
  }

  void _onDaySelected(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void calculateDateDifference(DateTime startDate, DateTime endDate) {
    setState(() {
      rangeDate = endDate.difference(startDate).inDays;
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(
          "Thêm công việc",
          style: headingStyle.copyWith(fontSize: 25),
        ),
        centerTitle: true,
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
            child: Skeletonizer(
              enabled: isLoading,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyInputField(
                      title: "Tên công việc",
                      hint: "Nhập tên công việc",
                      hintColor: kTextGreyColor,
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
                                          MediaQuery.of(context).size.height *
                                              0.4),
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedTaskType = newValue!['name'];
                                      _selectedTaskTypeId = newValue['id'];
                                    });
                                  },
                                  items: taskTypes.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: value,
                                      child: Text(value['name']),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  top: 17,
                                  left: 16,
                                  child: Text(_selectedTaskType))
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
                                          MediaQuery.of(context).size.height *
                                              0.4),
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedArea = newValue!['name'];
                                      _selectedField = "";
                                      _selectedExternalId = "";
                                      filteredField = [];
                                      filteredExternalId = [];
                                    });
                                    // Lọc danh sách Zone tương ứng với Area đã chọn
                                    widget.isPlant == null
                                        ? getZonesActivebyAreaId(
                                                newValue!['id'])
                                            .then((value) {
                                            setState(() {
                                              filteredZone = value;
                                              // Gọi setState để cập nhật danh sách zone
                                              _selectedZone = value.isEmpty
                                                  ? "Chưa có"
                                                  : "Chọn";
                                            });
                                          })
                                        : widget.isPlant == true
                                            ? getZonesbyAreaPlantId(
                                                    newValue!['id'])
                                                .then((value) {
                                                setState(() {
                                                  filteredZone = value;
                                                  // Gọi setState để cập nhật danh sách zone
                                                  _selectedZone = value.isEmpty
                                                      ? "Chưa có"
                                                      : "Chọn";
                                                });
                                              })
                                            : getZonesbyAreaLivestockId(
                                                    newValue!['id'])
                                                .then((value) {
                                                setState(() {
                                                  filteredZone = value;
                                                  // Gọi setState để cập nhật danh sách zone
                                                  _selectedZone = value.isEmpty
                                                      ? "Chưa có"
                                                      : "Chọn";
                                                });
                                              });
                                  },
                                  items: filteredArea.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
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
                            widget.isPlant == null ? "Vùng (tùy chọn)" : "Vùng",
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
                                          MediaQuery.of(context).size.height *
                                              0.4),
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  // value: _selectedArea,
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedZone = newValue!['nameCode'];
                                      _selectedExternalId = "";
                                      filteredExternalId = [];
                                    });
                                    // Lọc danh sách Filed tương ứng với Zone đã chọn
                                    getFieldsbyZoneId(newValue!['id'])
                                        .then((value) {
                                      setState(() {
                                        filteredField = value;
                                        _selectedField =
                                            value.isEmpty ? "Chưa có" : "Chọn";
                                      });
                                    });
                                  },
                                  items: filteredZone.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
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
                    if (_selectedZone == "Chưa có" && widget.isPlant != null)
                      Text(
                        "Hãy chọn khu vực khác",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isPlant == null
                                ? "Vườn/Chuồng (tùy chọn)"
                                : widget.isPlant == true
                                    ? "Vườn"
                                    : "Chuồng",
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
                                          MediaQuery.of(context).size.height *
                                              0.4),
                                  isExpanded: true,
                                  underline: Container(height: 0),
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      _selectedField = newValue!['nameCode'];
                                      fiedlId = newValue['id'];
                                    });

                                    if (widget.isOne &&
                                        widget.isPlant != null) {
                                      widget.isPlant == true
                                          ? getPlantExternalIdsbyFieldId(
                                                  newValue!['id'])
                                              .then((value) {
                                              setState(() {
                                                filteredExternalId = value;
                                                _selectedExternalId =
                                                    value.isEmpty
                                                        ? "Chưa có"
                                                        : "Chọn";
                                              });
                                            })
                                          : getLiveStockExternalIdsbyFieldId(
                                                  newValue!['id'])
                                              .then((value) {
                                              setState(() {
                                                filteredExternalId = value;
                                                _selectedExternalId =
                                                    value.isEmpty
                                                        ? "Chưa có"
                                                        : "Chọn";
                                              });
                                            });
                                    }
                                  },
                                  items: filteredField.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: value,
                                      child: Text(value['nameCode']),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  top: 17,
                                  left: 16,
                                  child: Text(_selectedField))
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_selectedField == "Chưa có" && widget.isPlant != null)
                      Text(
                        "Hãy chọn vùng khác",
                        style: TextStyle(
                            fontSize: 11, color: Colors.red, height: 2),
                      ),
                    if (widget.isOne && widget.isPlant != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isPlant == true
                                  ? "Mã cây trồng"
                                  : "Mã vật nuôi",
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
                                            MediaQuery.of(context).size.height *
                                                0.4),
                                    isExpanded: true,
                                    underline: Container(height: 0),
                                    // value: _selectedArea,
                                    onChanged:
                                        (Map<String, dynamic>? newValue) {
                                      setState(() {
                                        _selectedExternalId =
                                            newValue!['externalId'];
                                        widget.isPlant == true
                                            ? plantId = newValue['id']
                                            : liveStockId = newValue['id'];
                                      });
                                    },
                                    items: filteredExternalId.map<
                                            DropdownMenuItem<
                                                Map<String, dynamic>>>(
                                        (Map<String, dynamic> value) {
                                      return DropdownMenuItem<
                                          Map<String, dynamic>>(
                                        value: value,
                                        child: Text(value['externalId']),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Positioned(
                                    top: 17,
                                    left: 16,
                                    child: Text(_selectedExternalId))
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (_selectedExternalId == "Chưa có" &&
                        widget.isPlant != null)
                      widget.isPlant == true
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
                    if (widget.isPlant == null)
                      MyInputField(
                        title: "Địa chỉ chi tiết",
                        hint: "Mô tả chi tiết địa chỉ",
                        hintColor: kTextGreyColor,
                        controller: _addressDetailController,
                      ),
                    role == "Manager"
                        ? Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Người giám sát",
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
                                      child:
                                          DropdownButton2<Map<String, dynamic>>(
                                        dropdownStyleData: DropdownStyleData(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4),
                                        isExpanded: true,
                                        underline: Container(height: 0),
                                        // value: _selectedArea,
                                        onChanged:
                                            (Map<String, dynamic>? newValue) {
                                          setState(() {
                                            _selectedSupervisor =
                                                newValue!['name'];
                                            _selectedSupervisorId =
                                                newValue['id'];
                                          });
                                        },
                                        items: supervisors.map<
                                                DropdownMenuItem<
                                                    Map<String, dynamic>>>(
                                            (Map<String, dynamic> value) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: value,
                                            child: Text(value['name']),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Positioned(
                                        top: 17,
                                        left: 16,
                                        child: Text(_selectedSupervisor))
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dụng cụ (tùy chọn)", // Thay đổi tiêu đề nếu cần thiết
                            style:
                                titileStyle, // Đảm bảo bạn đã định nghĩa titileStyle
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
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Chọn dụng cụ cần thiết",
                                    hintStyle:
                                        TextStyle(color: Colors.black45)),
                                initialValue: [],
                                findSuggestions: (String query) {
                                  if (query.length != 0) {
                                    var lowercaseQuery =
                                        removeDiacritics(query.toLowerCase());
                                    return materials.where((m) {
                                      return removeDiacritics(
                                              m['name'].toLowerCase())
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
                                  selectedMaterials =
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
                                suggestionBuilder: (context, state, material) {
                                  return ListTile(
                                    key: ObjectKey(material),
                                    title: Text(material['name']),
                                    onTap: () =>
                                        state.selectSuggestion(material),
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
                                            _selectedRemind =
                                                int.parse(newValue!);
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
                                        // value: _selectedArea,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedRepeat = newValue!;
                                            showInputFieldRepeat = newValue;
                                            if (showInputFieldRepeat !=
                                                "Không") {
                                              for (int i = 1; i <= 30; i++) {
                                                repeatNumbers.add(i);
                                              }
                                            } else {
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
                                    Positioned(
                                        top: 17,
                                        left: 16,
                                        child: Text("$_selectedRepeat"))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (showInputFieldRepeat != "Không")
                            _selectedStartDate == null ||
                                    _selectedEndDate == null
                                ? Text(
                                    "Hãy chọn ngày giờ bắt đầu và kết thúc trước!",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red,
                                        height: 2),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          availableGestures:
                                              AvailableGestures.all,
                                          firstDay: _selectedEndDate!
                                              .add(Duration(days: 1)),
                                          focusedDay: _focusedDay,
                                          lastDay: DateTime.now()
                                              .add(Duration(days: 365)),
                                          onDaySelected: (date, events) {
                                            _onDaySelected(date);
                                            setState(() {
                                              if (selectedDatesRepeat
                                                  .contains(date)) {
                                                selectedDatesRepeat
                                                    .remove(date);
                                                removeDisabledDates(date);
                                              } else {
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
                                              selectedDatesRepeat.contains(day),
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
                                                  color: Colors.black,
                                                  fontSize: 16),
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
                                  "Độ ưu tiên",
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
                                            _selectedPriority = newValue!;
                                          });
                                        },
                                        items: priorities
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Positioned(
                                        top: 17,
                                        left: 16,
                                        child: Text(_selectedPriority))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  validateCreateDraft(context, widget.isPlant);
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
                                    "Lưu nháp",
                                    style: TextStyle(
                                      color: kTextWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  validateCreateTodo(context, widget.isPlant);
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
                                    "Giao việc",
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
                  ]),
            ),
          )),
    );
  }

  validateCreateDraft(context, isPlant) {
    if (_titleController.text.isNotEmpty) {
      createTaskDraft(createTaskData(isPlant)).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => BottomNavBar(
                      farmId: widget.farmId,
                      index: 1,
                      page: TaskPage(),
                    )),
            (route) => false,
          );
          SnackbarShowNoti.showSnackbar('Lưu công việc thành công', false);
        }
      }).catchError((e) {
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(
          "Để lưu công việc bạn cần điền tên công việc", true);
    }
  }

  validateCreateTodo(context, isPlant) {
    setState(() {
      isLoading = true;
    });

    if (isPlant == null) {
      if (_titleController.text.isNotEmpty &&
          _selectedTaskTypeId != null &&
          _selectedArea != "Chọn" &&
          _addressDetailController.text.isNotEmpty &&
          (role == "Supervisor" ||
              role == "Manager" && _selectedSupervisorId != null) &&
          _selectedStartDate != null &&
          _selectedEndDate != null &&
          (_selectedRepeat.toLowerCase() == "Có".toLowerCase() &&
                  selectedDatesRepeat.isNotEmpty ||
              _selectedRepeat.toLowerCase() == "Không".toLowerCase())) {
        createTask(isPlant);
      } else {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar(
            "Để giao việc bạn phải điền đầy đủ các dữ liệu cần thiết!", true);
      }
    } else if (fiedlId != null &&
        _selectedExternalId != "Chọn" &&
        _selectedExternalId != "Chưa có" &&
        _titleController.text.isNotEmpty &&
        _selectedTaskTypeId != null &&
        (role == "Supervisor" ||
            role == "Manager" && _selectedSupervisorId != null) &&
        _selectedStartDate != null &&
        _selectedEndDate != null &&
        (_selectedRepeat.toLowerCase() == "Có".toLowerCase() &&
                selectedDatesRepeat.isNotEmpty ||
            _selectedRepeat.toLowerCase() == "Không".toLowerCase())) {
      createTask(isPlant);
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(
          "Để giao việc bạn phải điền đầy đủ các dữ liệu cần thiết!", true);
    }
  }

  Map<String, dynamic> createTaskData(isPlant) {
    List<String> formattedDates = selectedDatesRepeat.map((date) {
      return DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(date);
    }).toList();
    Map<String, dynamic> taskData = {
      "materialIds": selectedMaterials.map<int>((m) => m['id'] as int).toList(),
      "dates": formattedDates,
      "farmTask": {
        "name": _titleController.text.trim(),
        "startDate": _selectedStartDate != null
            ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedStartDate!)
            : null,
        "endDate": _selectedEndDate != null
            ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(_selectedEndDate!)
            : null,
        "description": _desController.text.trim(),
        "priority": _selectedPriority,
        "isRepeat": _selectedRepeat.toLowerCase() == "Không".toLowerCase()
            ? false
            : true,
        "supervisorId": _selectedSupervisorId != null
            ? (role == "Manager" ? _selectedSupervisorId! : userId!)
            : null,
        "fieldId": fiedlId,
        "taskTypeId": _selectedTaskTypeId,
        "managerId": role == "Manager" ? userId : null,
        "plantId": plantId,
        "liveStockId": liveStockId,
        "remind": _selectedRemind,
        "addressDetail": isPlant == null
            ? (_selectedArea.isEmpty ||
                        _selectedArea == "Chưa có" ||
                        _selectedArea == "Chọn"
                    ? ""
                    : _selectedArea + ", ") +
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
                _addressDetailController.text.trim()
            : null,
        "isPlant": isPlant,
        "isSpecific": widget.isOne
      }
    };
    return taskData;
  }

  void createTask(isPlant) {
    createTaskTodo(createTaskData(isPlant)).then((value) {
      if (value) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => BottomNavBar(
                    farmId: widget.farmId,
                    index: 1,
                    page: TaskPage(),
                  )),
          (route) => false,
        );
        SnackbarShowNoti.showSnackbar('Giao công việc thành công', false);
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(e.toString(), true);
    });
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
}
