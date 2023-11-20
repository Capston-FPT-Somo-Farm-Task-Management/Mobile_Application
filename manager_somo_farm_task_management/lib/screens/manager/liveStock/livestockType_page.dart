import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';
import 'package:manager_somo_farm_task_management/models/livestock.dart';
import 'package:manager_somo_farm_task_management/screens/manager/habitantTpe_detail/habitantType_detail_popup.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock_add/add_liveStockType_page.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class LiveStockTypePage extends StatefulWidget {
  final int farmId;
  const LiveStockTypePage({Key? key, required this.farmId}) : super(key: key);

  @override
  LiveStockTypePageState createState() => LiveStockTypePageState();
}

class LiveStockTypePageState extends State<LiveStockTypePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> filteredLivestockList = [];
  final TextEditingController searchController = TextEditingController();

  void searchLiveStockType(String keyword) {
    setState(() {
      filteredLivestockList = liveStocks
          .where((a) => removeDiacritics(a['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  List<Map<String, dynamic>> liveStocks = [];

  Future<void> GetAllLiveStockType() async {
    HabitantTypeService()
        .getLiveStockTypeFromHabitantType(widget.farmId)
        .then((value) {
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

  Future<bool> deleteHabitantType(int id) {
    return HabitantTypeService().DeleteHabitantType(id);
  }

  Future<void> _initializeData() async {
    await GetAllLiveStockType();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isLoading = false;
      });
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
          'Loại vật nuôi',
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
                                  builder: (context) => CreateLiveStockType(
                                      farmId: widget.farmId)),
                            ).then((value) {
                              if (value != null) {
                                GetAllLiveStockType();
                                SnackbarShowNoti.showSnackbar(
                                    'Tạo loại thành công!', false);
                              }
                            });
                            ;
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
                              "Tạo loại vật nuôi",
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
                          searchLiveStockType(keyword);
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
                                "Không có loại vật nuôi",
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
                          onRefresh: () => GetAllLiveStockType(),
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredLivestockList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> liveStock =
                                  filteredLivestockList[index];

                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return HabitantTypeDetailPopup(
                                            habitantType: liveStock);
                                      },
                                    ).then(
                                      (value) => {
                                        if (value != null)
                                          {GetAllLiveStockType()}
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
                                          blurRadius: 8,
                                          offset:
                                              Offset(2, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 150,
                                      width: double.infinity,
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
                                                    Flexible(
                                                      child: Text(
                                                        liveStock['name'],
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: liveStock[
                                                                    'isActive'] ==
                                                                false
                                                            ? Colors.red[400]
                                                            : kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        liveStock['isActive'] ==
                                                                true
                                                            ? "Hiện"
                                                            : "Ẩn",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 7),
                                                      height: 70,
                                                      width: 4,
                                                      decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(20),
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
                                                                    "Xuất xứ: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black87),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    '${liveStock['origin']}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black87),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Môi trường sống: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black87),
                                                              ),
                                                              TextSpan(
                                                                text: liveStock[
                                                                            'environment'] ==
                                                                        null
                                                                    ? "chưa có"
                                                                    : wrapWordsWithEllipsis(
                                                                        '${liveStock['environment']}',
                                                                        20),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black87),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                label: liveStock['isActive'] == false
                    ? "Hiện vật nuôi"
                    : "Ẩn vật nuôi",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Thay đổi trạng thái loại vật nuôi",
                          content:
                              "Bạn có chắc muốn thay đổi trạng thái của loại vật nuôi này?",
                          onConfirm: () {
                            deleteHabitantType(liveStock['id']).then((value) {
                              if (value) {
                                GetAllLiveStockType();
                                SnackbarShowNoti.showSnackbar(
                                    'Đổi trạng thái thành công!', false);
                              } else {
                                SnackbarShowNoti.showSnackbar(
                                    'Loại vật nuôi đang được sử dụng. Không thể thay đổi trạng thái',
                                    true);
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          buttonConfirmText: "Thay đổi",
                        );
                      });
                },
                cls: liveStock['isActive'] == false
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
