import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock_add/add_liveStockGroup_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock_detail/liveStock_field_detail_popup.dart';
import 'package:manager_somo_farm_task_management/services/field_service.dart';
import 'package:manager_somo_farm_task_management/services/livestock_service.dart';

import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveStockFieldPage extends StatefulWidget {
  final int farmId;
  const LiveStockFieldPage({Key? key, required this.farmId}) : super(key: key);

  @override
  LiveStockFieldPageState createState() => LiveStockFieldPageState();
}

class LiveStockFieldPageState extends State<LiveStockFieldPage> {
  int? farmId;
  List<Map<String, dynamic>> filteredLivestockList = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  void searchLiveStock(String keyword) {
    setState(() {
      filteredLivestockList = liveStocks
          .where((a) => removeDiacritics(a['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<List<Map<String, dynamic>>> getLiveStockByFarmId(int id) {
    return LiveStockService().getLiveStockByFarmId(id);
  }

  Future<List<Map<String, dynamic>>> getLiveStockFieldByFarmId(int id) {
    return FieldService().getLiveStockFieldByFarmId(id);
  }

  Future<bool> deleteField(int id) {
    return FieldService().DeleteField(id);
  }

  Future<void> GetLiveStockFields() async {
    FieldService().getLiveStockFieldByFarmId(widget.farmId).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.isNotEmpty) {
        setState(() {
          liveStocks = value;
          filteredLivestockList = liveStocks;
          isLoading = false;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<void> _initializeData() async {
    await getFarmId();
    await GetLiveStockFields();
  }

  List<Map<String, dynamic>> liveStocks = [];

  @override
  void initState() {
    super.initState();
    getFarmId().then((value) {
      farmId = value;
    });
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Chuồng của vật nuôi',
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
                                  builder: (context) => CreateLiveStockGroup(
                                        farmId: farmId!,
                                      )),
                            ).then((value) {
                              if (value != null) {
                                GetLiveStockFields();
                                SnackbarShowNoti.showSnackbar(
                                    'Tạo chuồng thành công!', false);
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
                              "Tạo chuồng",
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
                          searchLiveStock(keyword);
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
                  : filteredLivestockList.isEmpty
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
                                "Không có chuồng",
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
                          onRefresh: () => GetLiveStockFields(),
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredLivestockList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> liveStock =
                                  filteredLivestockList[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return LiveStockFieldDetailsPopup(
                                            liveStockField: liveStock);
                                      },
                                    ).then(
                                      (value) => {
                                        if (value != null)
                                          {GetLiveStockFields()}
                                      },
                                    );
                                  },
                                  onLongPress: () {
                                    _showBottomSheet(context, liveStock);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 7,
                                          offset:
                                              Offset(1, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 10,
                                                left: 15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            height: 130,
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
                                                          Flexible(
                                                            child: Text(
                                                              liveStock['name'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 21,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: liveStock[
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
                                                              liveStock['isDelete'] ==
                                                                      false
                                                                  ? "Hiện"
                                                                  : "Ẩn",
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
                                                      SizedBox(height: 5),
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
                                                          SizedBox(width: 8),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .tag,
                                                                    color:
                                                                        kSecondColor,
                                                                    size: 17,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 7),
                                                                  TitleText.titleText(
                                                                      "Mã chuồng",
                                                                      "${liveStock['code']}",
                                                                      16),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .map,
                                                                    color:
                                                                        kSecondColor,
                                                                    size: 17,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  TitleText.titleText(
                                                                      "Khu vực",
                                                                      wrapWordsWithEllipsis(
                                                                          "${liveStock['areaName']}",
                                                                          30),
                                                                      16),
                                                                ],
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
                                                  wrapWordsWithEllipsis(
                                                      '${liveStock['zoneName']}',
                                                      25),
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  wrapWordsWithEllipsis(
                                                      '${liveStock['area']} mét vuông',
                                                      20),
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

  _showBottomSheet(BuildContext context, Map<String, dynamic> liveStock) {
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
                label:
                    liveStock['isDelete'] == true ? "Hiện chuồng" : "Ẩn chuồng",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Thay đổi trạng thái chuồng",
                          content:
                              "Bạn có chắc muốn thay đổi trạng thái của chuồng này?",
                          onConfirm: () {
                            deleteField(liveStock['id']).then((value) {
                              if (value) {
                                GetLiveStockFields();
                                SnackbarShowNoti.showSnackbar(
                                    'Đổi trạng thái thành công!', false);
                              } else {
                                SnackbarShowNoti.showSnackbar(
                                    'Trong chuồng còn con vật! Không thể thay đổi trạng thái',
                                    true);
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          buttonConfirmText: "Thay đổi",
                        );
                      });
                },
                cls: liveStock['isDelete'] == true
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
