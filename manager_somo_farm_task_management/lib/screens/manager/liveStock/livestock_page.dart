import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/models/livestock.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock_add/add_livestock_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock_detail/liveStock_detail_popup.dart';
import 'package:manager_somo_farm_task_management/services/livestock_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/app_bar.dart';

class LiveStockPage extends StatefulWidget {
  final int farmId;
  const LiveStockPage({super.key, required this.farmId});

  @override
  LiveStockPageState createState() => LiveStockPageState();
}

class LiveStockPageState extends State<LiveStockPage> {
  bool isLoading = true;
  List<LiveStock> SearchliveStock = plantList;
  final TextEditingController searchController = TextEditingController();

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  void searchLiveStocks(String keyword) {
    setState(() {
      SearchliveStock = plantList
          .where((liveStock) => removeDiacritics(liveStock.name.toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<bool> deleteLiveStock(int id) {
    return LiveStockService().deleteLiveStock(id);
  }

  Future<List<Map<String, dynamic>>> getLiveStockByFarmId(int id) {
    return LiveStockService().getLiveStockByFarmId(id);
  }

  Future<List<Map<String, dynamic>>> GetAllLiveStock() {
    return LiveStockService().getAllLiveStock();
  }

  List<Map<String, dynamic>> liveStocks = [];

  Future<void> GetLiveStocks() async {
    LiveStockService().getLiveStockByFarmId(widget.farmId).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.isNotEmpty) {
        setState(() {
          liveStocks = value;
          isLoading = false;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<void> _initializeData() async {
    await GetLiveStocks();
  }

  @override
  initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Vật nuôi",
                      style: TextStyle(
                        fontSize: 28,
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
                                  builder: (context) => CreateLiveStock(
                                        farmId: widget.farmId,
                                      )),
                            );
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
                              "Tạo vật nuôi",
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
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (keyword) {
                          searchLiveStocks(keyword);
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
              child: RefreshIndicator(
                onRefresh: () => GetLiveStocks(),
                child: ListView.builder(
                  itemCount: liveStocks.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> liveStock = liveStocks[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LiveStockDetailsPopup(
                                  liveStock: liveStock);
                            },
                          );
                        },
                        onLongPress: () {
                          _showBottomSheet(context, liveStock);
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
                                      color: Colors.grey, // Màu của đường viền
                                      width: 1.0, // Độ dày của đường viền
                                    ),
                                  ),
                                  height: 120,
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
                                                Text(
                                                  liveStock['name'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        liveStock['status'] ==
                                                                "Inactive"
                                                            ? Colors.red[400]
                                                            : kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    liveStock['status'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Giống ${liveStock['gender']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${liveStock['areaName']}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400], // Đặt màu xám ở đây
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${liveStock['zoneName']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${liveStock['fieldName']}',
                                        style: const TextStyle(fontSize: 16),
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
                label: liveStock['status'] == "Inactive"
                    ? "Đổi sang Active"
                    : "Đổi sang Inactive",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Thay đổi trạng thái con vật",
                          content:
                              "Bạn có chắc muốn thay đổi trạng thái của con vật này?",
                          onConfirm: () {
                            setState(() {
                              deleteLiveStock(liveStock['id']);
                              GetLiveStocks();
                              Navigator.of(context).pop();
                              SnackbarShowNoti.showSnackbar(
                                  'Đổi trạng thái thành công!', false);
                              deleteLiveStock(liveStock['id']);
                            });
                          },
                          buttonConfirmText: "Thay đổi",
                        );
                      });
                },
                cls: liveStock['status'] == "Inactive"
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
