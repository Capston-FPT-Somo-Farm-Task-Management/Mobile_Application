import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/employee_detail/employee_details_popup.dart';
import 'package:manager_somo_farm_task_management/screens/manager/zone_add/zone_add_page.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:manager_somo_farm_task_management/services/zone_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../../../widgets/app_bar.dart';

class ZonePage extends StatefulWidget {
  final int farmId;
  const ZonePage({super.key, required this.farmId});

  @override
  ZonePageState createState() => ZonePageState();
}

class ZonePageState extends State<ZonePage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> zones = [];
  List<Map<String, dynamic>> filteredZoneList = [];
  String selectedFilter = "";
  bool isLoading = true;
  List<Map<String, dynamic>> areaFilters = [];
  @override
  initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getZones();
    await getAreas();
  }

  void searchZones(String keyword) {
    setState(() {
      filteredZoneList = zones
          .where((z) => removeDiacritics(z['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> getZones() async {
    ZoneService().getZonesbyFarmId(widget.farmId).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          zones = value;
          filteredZoneList = zones;
          isLoading = false;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<void> getAreas() async {
    AreaService().getAreasByFarmId(widget.farmId).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          areaFilters = [
            {"name": "Tất cả khu vực"},
            ...value
          ];
          selectedFilter = areaFilters.first['name'];
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<List<Map<String, dynamic>>> getZonesbyAreaId(int areaId) {
    return ZoneService().getZonesbyAreaId(areaId);
  }

  Future<bool> changeStatusZone(int id) async {
    return ZoneService().changeStatusZone(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Vùng",
                      style: TextStyle(
                        fontSize: 28, // Thay đổi kích thước phù hợp
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateZone(
                                        farmId: widget.farmId,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                getZones();
                                SnackbarShowNoti.showSnackbar(
                                    context, 'Tạo vùng thành công!', false);
                              }
                            });
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
                              "Thêm vùng",
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 42,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (keyword) {
                          searchZones(keyword);
                        },
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Màu đường viền
                            width: 1.0, // Độ rộng của đường viền
                          ),
                          borderRadius: BorderRadius.circular(
                              5.0), // Độ bo góc của đường viền
                        ),
                        child: DropdownButton<Map<String, dynamic>>(
                          isDense: true,
                          alignment: Alignment.center,
                          hint: Text(selectedFilter),
                          onChanged: (Map<String, dynamic>? newValue) {
                            if (newValue!['name'] == "Tất cả khu vực") {
                              getZones();
                            } else {
                              getZonesbyAreaId(newValue['id']).then((value) {
                                setState(() {
                                  filteredZoneList = value;
                                  selectedFilter = newValue['name'];
                                });
                              });
                            }
                          },
                          items: areaFilters
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
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              flex: 3,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : filteredZoneList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_accounts_outlined,
                                size:
                                    75, // Kích thước biểu tượng có thể điều chỉnh
                                color: Colors.grey, // Màu của biểu tượng
                              ),
                              SizedBox(
                                  height:
                                      16), // Khoảng cách giữa biểu tượng và văn bản
                              Text(
                                "Không có vùng nào",
                                style: TextStyle(
                                  fontSize:
                                      20, // Kích thước văn bản có thể điều chỉnh
                                  color: Colors.grey, // Màu văn bản
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => getZones(),
                          child: ListView.separated(
                            itemCount: filteredZoneList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 25);
                            },
                            itemBuilder: (context, index) {
                              final task = filteredZoneList[index];

                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EmployeeDetailsPopup(
                                          employee: task);
                                    },
                                  );
                                },
                                onLongPress: () {
                                  _showBottomSheet(context, task);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        offset: Offset(0, 6), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors
                                                .grey, // Màu của đường viền
                                            width: 1.0, // Độ dày của đường viền
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        task['name'].length > 20
                                                            ? '${task['name'].substring(0, 20)}...'
                                                            : task['name'],
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: task['status'] ==
                                                                  "Inactive"
                                                              ? Colors.red[400]
                                                              : kPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          task['status'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Icon(
                                                        Icons.api,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "Thuộc khu vực: ${task['areaName']}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Icon(
                                                        Icons.api,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "Loại vùng: ${task['zoneTypeName']}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Map<String, dynamic> employee) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.24,
          color: kBackgroundColor,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kTextGreyColor,
                ),
              ),
              const Spacer(),
              _bottomSheetButton(
                label: employee['status'] == "Inactive"
                    ? "Đổi sang Actice"
                    : "Đổi sang Inactive",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context1) {
                        return ConfirmDeleteDialog(
                          title: "Đổi trạng thái",
                          content: "Bạn có chắc muốn đổi trạng thái nhân viên?",
                          onConfirm: () {
                            changeStatusZone(employee['id']).then((value) {
                              if (value) {
                                getZones();
                                Navigator.of(context).pop();
                                SnackbarShowNoti.showSnackbar(context,
                                    'Đổi trạng thái thành công!', false);
                              } else {
                                SnackbarShowNoti.showSnackbar(context,
                                    'Đổi trạng thái không thành công!', true);
                              }
                            });
                          },
                          buttonConfirmText: "Có",
                        );
                      });
                },
                cls: employee['status'] == "Inactive"
                    ? kPrimaryColor
                    : Colors.red[300]!,
                context: context,
              ),
              const SizedBox(height: 20),
              _bottomSheetButton(
                label: "Đóng",
                onTap: () {
                  Navigator.of(context).pop();
                },
                cls: Colors.white,
                isClose: true,
                context: context,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color cls,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.grey[300]! : cls,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : cls,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titileStyle
                : titileStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
