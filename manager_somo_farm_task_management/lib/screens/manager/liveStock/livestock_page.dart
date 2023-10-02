import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/models/livestock.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_liveStock/add_liveStockGroup_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_liveStock/add_liveStockType_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_liveStock/add_livestock_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock_detail/liveStock_detail_popup.dart';
import 'package:manager_somo_farm_task_management/services/livestock_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/bottom_navigation_bar.dart';

class LiveStockPage extends StatefulWidget {
  const LiveStockPage({Key? key}) : super(key: key);

  @override
  LiveStockPageState createState() => LiveStockPageState();
}

class LiveStockPageState extends State<LiveStockPage> {
  int? farmId;
  int _currentIndex = 0;
  List<LiveStock> SearchliveStock = liveStockList;
  final TextEditingController searchController = TextEditingController();

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  void searchLiveStocks(String keyword) {
    setState(() {
      SearchliveStock = liveStockList
          .where((liveStock) => removeDiacritics(liveStock.name.toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<Map<String, dynamic>> deleteLiveStock(int id, String status) {
    return LiveStockService().deleteLiveStock(id, status);
  }

  List<Map<String, dynamic>> liveStocks = [];

  @override
  void initState() {
    super.initState();
    getFarmId().then((value) {
      farmId = value;
    });
    GetAllLiveStock().then((value) {
      setState(() {
        liveStocks = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> GetAllLiveStock() {
    return LiveStockService().getAllLiveStock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
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
                                          farmId: farmId!,
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateLiveStockGroup(
                                          farmId: farmId!,
                                        )),
                              );
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
                                "Tạo chuồng",
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                          )
                        ],
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
                                    builder: (context) =>
                                        CreateLiveStockType()),
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
                                "Tạo loại vật nuôi",
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
                      child: Expanded(
                        flex: 2,
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Flexible(
                flex: 2,
                child: ListView.builder(
                  itemCount: liveStocks.length,
                  // separatorBuilder: (BuildContext context, int index) {
                  //   return const SizedBox(height: 25);
                  // },
                  itemBuilder: (context, index) {
                    Map<String, dynamic> liveStock = liveStocks[index];

                    if (liveStock['status'] == 'Inactive') {
                      return SizedBox.shrink();
                    }
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
                                  height: 110,
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
                                            Text(
                                              liveStock['name'],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(liveStock['createDate']))}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Loại: ${liveStock['habitantTypeName']}',
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
                                        'Khu đất: ${liveStock['fieldName']}',
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
            ],
          )),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
                label: "Xóa",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Xóa con vật",
                          content: "Bạn có chắc muốn xóa con vật này?",
                          onConfirm: () {
                            Navigator.of(context).pop();
                            setState(() {});
                            liveStocks.remove(liveStock);
                            deleteLiveStock(
                                liveStock['id'], liveStock['status']);
                          },
                          buttonConfirmText: "Xóa",
                        );
                      });
                  SnackbarShowNoti.showSnackbar(
                      context, 'Xóa thành công vật nuôi', true);
                },
                cls: Colors.red[300]!,
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