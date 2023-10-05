import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/area_add/area_add.dart';
import 'package:manager_somo_farm_task_management/screens/manager/employee_detail/employee_details_popup.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../../../widgets/app_bar.dart';

class AreakPage extends StatefulWidget {
  final int farmId;
  const AreakPage({super.key, required this.farmId});

  @override
  AreakPageState createState() => AreakPageState();
}

class AreakPageState extends State<AreakPage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> areas = [];
  List<Map<String, dynamic>> filteredareaList = [];
  String? selectedFilter;
  bool isLoading = true;
  @override
  initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getAreas();
  }

  void searchEmployees(String keyword) {
    setState(() {
      filteredareaList = areas
          .where((task) => removeDiacritics(task['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> getAreas() async {
    AreaService().getAreasByFarmId(widget.farmId).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          areas = value;
          filteredareaList = areas;
          isLoading = false;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<bool> changeStatusEmployee(int id) async {
    return EmployeeService().changeStatusEmployee(id);
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
                      "Khu vực",
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
                                  builder: (context) => CreateArea()),
                            ).then((value) {
                              if (value != null) {
                                getAreas();
                                SnackbarShowNoti.showSnackbar(
                                    context, 'Tạo khu vực thành công!', false);
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
                              "Thêm khu vực",
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
                          searchEmployees(keyword);
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(
                  //           color: Colors.grey, // Màu đường viền
                  //           width: 1.0, // Độ rộng của đường viền
                  //         ),
                  //         borderRadius: BorderRadius.circular(
                  //             5.0), // Độ bo góc của đường viền
                  //       ),
                  //       child: DropdownButton<String>(
                  //         isDense: true,
                  //         alignment: Alignment.center,
                  //         hint: Text(selectedFilter!),
                  //         value:
                  //             selectedFilter, // Giá trị đã chọn cho Dropdown 1
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             selectedFilter =
                  //                 newValue; // Cập nhật giá trị đã chọn cho Dropdown 1
                  //             if (selectedFilter == "Tất cả") {
                  //               filteredareaList = areas;
                  //             }
                  //             if (selectedFilter == "Active") {
                  //               filteredareaList = areas
                  //                   .where((t) => t['status'] == "Active")
                  //                   .toList();
                  //             }
                  //             if (selectedFilter == "Inactive") {
                  //               filteredareaList = areas
                  //                   .where((t) => t['status'] == "Inactive")
                  //                   .toList();
                  //             }
                  //           });
                  //         },
                  //         items: filters
                  //             .map<DropdownMenuItem<String>>((String value) {
                  //           return DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Text(value),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     )
                  //   ],
                  // )
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
                  : filteredareaList.isEmpty
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
                                "Không có khu vực nào",
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
                          onRefresh: () => getAreas(),
                          child: ListView.separated(
                            itemCount: filteredareaList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 25);
                            },
                            itemBuilder: (context, index) {
                              final employee = filteredareaList[index];

                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EmployeeDetailsPopup(
                                          employee: employee);
                                    },
                                  );
                                },
                                onLongPress: () {
                                  _showBottomSheet(context, employee);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 7,
                                        offset: Offset(4, 8), // Shadow position
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
                                                        employee['name']
                                                                    .length >
                                                                20
                                                            ? '${employee['name'].substring(0, 20)}...'
                                                            : employee['name'],
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   decoration:
                                                      //       BoxDecoration(
                                                      //     color: employee[
                                                      //                 'status'] ==
                                                      //             "Inactive"
                                                      //         ? Colors.red[400]
                                                      //         : kPrimaryColor,
                                                      //     borderRadius:
                                                      //         BorderRadius
                                                      //             .circular(10),
                                                      //   ),
                                                      //   padding:
                                                      //       const EdgeInsets
                                                      //           .all(10),
                                                      //   child: Text(
                                                      //     employee['status'],
                                                      //     style:
                                                      //         const TextStyle(
                                                      //             fontSize: 14,
                                                      //             fontWeight:
                                                      //                 FontWeight
                                                      //                     .bold,
                                                      //             color: Colors
                                                      //                 .white),
                                                      //   ),
                                                      // ),
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
                                                        "Diện tích: ${employee['fArea']}",
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
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .grey[400], // Đặt màu xám ở đây
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        height: 45,
                                        // child: Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text(
                                        //       'Địa chỉ: ${employee['address'].length > 33 ? '${employee['address'].substring(0, 33)}...' : employee['address']}',
                                        //       style:
                                        //           const TextStyle(fontSize: 16),
                                        //     ),
                                        //   ],
                                        // ),
                                      )
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
                            changeStatusEmployee(employee['id']).then((value) {
                              if (value) {
                                getAreas();
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