import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/services/farm_service.dart';

class IntroducingFarmPage extends StatefulWidget {
  final int farmId;

  const IntroducingFarmPage({Key? key, required this.farmId}) : super(key: key);

  @override
  State<IntroducingFarmPage> createState() => _IntroducingFarmPageState();
}

class _IntroducingFarmPageState extends State<IntroducingFarmPage> {
  Map<String, dynamic>? farmData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadFarmData();
  }

  Future<void> _loadFarmData() async {
    GetFarm(widget.farmId).then((value) {
      setState(() {
        isLoading = false;
        if (value.isNotEmpty) {
          setState(() {
            farmData = value;
          });
        }
      });
    });
  }

  Future<Map<String, dynamic>> GetFarm(int farmId) {
    return FarmService().getFarmById(farmId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thông tin nông trại',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
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
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: SingleChildScrollView(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  )
                : farmData == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.not_interested_sharp,
                              size: 75,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Không thể hiện farm ngay lúc này",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadFarmData(),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 20),
                              child: Container(
                                width: 450,
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.6), // Màu của bóng
                                      offset: Offset(
                                          10, 10), // Điểm bắt đầu của bóng
                                      blurRadius: 10, // Độ mờ của bóng
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(100),
                                  ),
                                  child: Image.network(
                                    '${farmData!['urlImage']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      farmData != null ? farmData!['name'] : '',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ("Địa chỉ"),
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            farmData != null
                                                ? farmData!['address']
                                                : '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              letterSpacing: 1.2,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ("Giới thiệu"),
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            farmData != null
                                                ? farmData!['description']
                                                : '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              letterSpacing: 1.2,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
