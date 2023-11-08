import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/material_add/material_add_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/material_update/material_update_page.dart';
import 'package:manager_somo_farm_task_management/services/material_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

import '../../../widgets/app_bar.dart';

class MaterialsPage extends StatefulWidget {
  final int farmId;
  const MaterialsPage({super.key, required this.farmId});

  @override
  MaterialPageState createState() => MaterialPageState();
}

class MaterialPageState extends State<MaterialsPage> {
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
    await getMaterials();
  }

  void searchMaterials(String keyword) {
    setState(() {
      filteredareaList = areas
          .where((a) => removeDiacritics(a['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> getMaterials() async {
    MaterialService().getMaterialAllByFamrId(widget.farmId).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.isNotEmpty) {
        setState(() {
          areas = value;
          filteredareaList = areas;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<bool> changeStatusMaterial(int id) async {
    return MaterialService().changeStatusMaterial(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
        color: Colors.grey[200],
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
                      "Dụng cụ",
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
                                  builder: (context) => CreateMaterial(
                                        farmId: widget.farmId,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                getMaterials();
                                SnackbarShowNoti.showSnackbar(
                                    'Tạo công cụ thành công!', false);
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
                              "Thêm dụng cụ",
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (keyword) {
                          searchMaterials(keyword);
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
                                "Không có dụng cụ nào",
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
                          notificationPredicate: (_) => true,
                          onRefresh: () => getMaterials(),
                          child: ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredareaList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 20);
                            },
                            itemBuilder: (context, index) {
                              final task = filteredareaList[index];

                              return GestureDetector(
                                // onTap: () {
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return EmployeeDetailsPopup(
                                //           employee: task);
                                //     },
                                //   );
                                // },
                                onLongPress: () {
                                  _showBottomSheet(context, task);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 50,
                                                            width: 50,
                                                            child:
                                                                Image.network(
                                                              task['urlImage'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            task['name'].length >
                                                                    20
                                                                ? '${task['name'].substring(0, 20)}...'
                                                                : task['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
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
          height: MediaQuery.of(context).size.height * 0.3,
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
                label: "Chỉnh sửa",
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => UpdateMaterial(
                        material: employee,
                      ),
                    ),
                  )
                      .then((value) {
                    if (value != null) {
                      getMaterials();
                      SnackbarShowNoti.showSnackbar(
                          'Chỉnh sửa thành công!', false);
                    }
                  });
                },
                cls: kPrimaryColor,
                context: context,
              ),
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
                          content: "Bạn có chắc muốn đổi trạng thái dụng cụ?",
                          onConfirm: () {
                            Navigator.of(context).pop();
                            changeStatusMaterial(employee['id']).then((value) {
                              if (value) {
                                getMaterials();

                                SnackbarShowNoti.showSnackbar(
                                    'Đổi trạng thái thành công!', false);
                              } else {
                                SnackbarShowNoti.showSnackbar(
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
