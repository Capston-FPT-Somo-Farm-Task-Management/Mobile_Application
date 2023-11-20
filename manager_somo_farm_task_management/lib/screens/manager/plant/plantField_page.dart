import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/models/livestock.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant_add/add_plantField_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant_detail/plant_field_detail_popup.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantFieldPage extends StatefulWidget {
  final farmId;
  const PlantFieldPage({Key? key, this.farmId}) : super(key: key);

  @override
  PlantFieldPageState createState() => PlantFieldPageState();
}

class PlantFieldPageState extends State<PlantFieldPage> {
  int? farmId;
  List<Map<String, dynamic>> filteredPlantList = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  void searchPlant(String keyword) {
    setState(() {
      filteredPlantList = plants
          .where((a) => removeDiacritics(a['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<bool> deleteField(int id) {
    return FieldService().DeleteField(id);
  }

  Future<void> GetPlantFields() async {
    FieldService().getPlantFieldByFarmId(widget.farmId).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.isNotEmpty) {
        setState(() {
          plants = value;
          filteredPlantList = plants;
          isLoading = false;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<void> _initializeData() async {
    await getFarmId();
    await GetPlantFields();
  }

  List<Map<String, dynamic>> plants = [];

  @override
  void initState() {
    super.initState();
    getFarmId().then((value) {
      farmId = value;
    });
    _initializeData();
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Vườn cây',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            iconSize: 35,
            onPressed: () {
              HamburgerMenu.showReusableBottomSheet(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreatePlantField(
                                  farmId: farmId!,
                                ),
                              ),
                            ).then((value) {
                              if (value != null) {
                                GetPlantFields();
                                SnackbarShowNoti.showSnackbar(
                                    'Tạo vườn thành công!', false);
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: Size(120, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Tạo vườn cây",
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                          searchPlant(keyword);
                        },
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              flex: 2,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : filteredPlantList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.not_interested,
                                size:
                                    75, // Kích thước biểu tượng có thể điều chỉnh
                                color: Colors.grey, // Màu của biểu tượng
                              ),
                              SizedBox(
                                  height:
                                      16), // Khoảng cách giữa biểu tượng và văn bản
                              Text(
                                "Không có vườn cây",
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
                          onRefresh: () => GetPlantFields(),
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredPlantList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> plant =
                                  filteredPlantList[index];

                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PlantFieldDetailsPopup(
                                            plantField: plant);
                                      },
                                    ).then((value) => {
                                          if (value != null) {GetPlantFields()}
                                        });
                                  },
                                  onLongPress: () {
                                    _showBottomSheet(context, plant);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10,
                                          offset:
                                              Offset(1, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            height: 120,
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            plant['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: plant[
                                                                          'isDelete'] ==
                                                                      true
                                                                  ? Colors
                                                                      .red[400]
                                                                  : kPrimaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Text(
                                                              plant['isDelete'] ==
                                                                      false
                                                                  ? "Active"
                                                                  : "Inactive",
                                                              style: const TextStyle(
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
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 7),
                                                            height: 60,
                                                            width: 4,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "Mã vườn: ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          '${plant['code']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black87),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "Địa điểm: ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          '${plant['areaName']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black87),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.green[
                                                100], // Đặt màu xám ở đây
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          height: 45,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${plant['zoneName']}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
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

  _showBottomSheet(BuildContext context, Map<String, dynamic> plant) {
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
                label: plant['isDelete'] == true
                    ? "Đổi sang Active"
                    : "Đổi sang Inactive",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Thay đổi trạng thái vườn",
                          content:
                              "Bạn có chắc muốn thay đổi trạng thái của vườn này?",
                          onConfirm: () {
                            deleteField(plant['id']).then((value) {
                              if (value) {
                                GetPlantFields();
                                SnackbarShowNoti.showSnackbar(
                                    'Đổi trạng thái thành công!', false);
                              } else {
                                SnackbarShowNoti.showSnackbar(
                                    'Trong vườn còn cây trồng! Không thể thay đổi trạng thái',
                                    true);
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          buttonConfirmText: "Thay đổi",
                        );
                      });
                },
                cls: plant['isDelete'] == true
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
