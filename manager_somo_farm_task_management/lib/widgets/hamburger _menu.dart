import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/screens/manager/area/area_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/employee/employee_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestockField_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestockType_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestock_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/material/material_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plantField_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plantType_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plant_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/zone/zone_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/task_page.dart';
import 'package:manager_somo_farm_task_management/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReusableBottomSheet extends StatefulWidget {
  final String title;
  ReusableBottomSheet({required this.title});

  @override
  State<ReusableBottomSheet> createState() => _ReusableBottomSheetState();
}

class _ReusableBottomSheetState extends State<ReusableBottomSheet> {
  int? farmId;

  bool isVisibleLiveStock = false;

  bool isVisiblePlant = false;

  double padingForAll = 16;

  String? role;

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    return storedFarmId;
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  @override
  initState() {
    super.initState();
    getFarmId().then((value) {
      farmId = value;
    });
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (role == "Supervisor") ...[
                SizedBox(height: 25),
                Container(
                  padding:
                      EdgeInsets.only(left: padingForAll, right: padingForAll),
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn lề trái
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                            farmId: farmId!,
                            index: 0,
                            page: TaskPage(),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.check_circle),
                        SizedBox(width: 15),
                        Text(
                          "Công việc",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding:
                      EdgeInsets.only(left: padingForAll, right: padingForAll),
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn lề trái
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                            farmId: farmId!,
                            index: 0,
                            page: EmployeekPage(role: role!),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.timer),
                        SizedBox(width: 15),
                        Text(
                          "Thời gian làm việc",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
              if (role == "Manager") ...[
                Container(
                  padding: EdgeInsets.only(
                      top: padingForAll,
                      left: padingForAll,
                      right: padingForAll),
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn lề trái
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                            farmId: farmId!,
                            index: 0,
                            page: AreaPage(
                              farmId: farmId!,
                            ),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(FontAwesomeIcons.mapPin),
                        SizedBox(width: 15),
                        Text(
                          "Khu vực",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding:
                      EdgeInsets.only(left: padingForAll, right: padingForAll),
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn lề trái
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                            farmId: farmId!,
                            index: 0,
                            page: ZonePage(
                              farmId: farmId!,
                            ),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.border_inner_outlined),
                        SizedBox(width: 15),
                        Text(
                          "Vùng",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding:
                      EdgeInsets.only(left: padingForAll, right: padingForAll),
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn lề trái
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                            farmId: farmId!,
                            index: 0,
                            page: TaskPage(),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.check_circle),
                        SizedBox(width: 15),
                        Text(
                          "Công việc",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: padingForAll - 9,
                      left: padingForAll,
                      right: padingForAll,
                    ),
                    color: isVisibleLiveStock ? Colors.grey[300] : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BottomNavBar(
                                    farmId: farmId!,
                                    index: 0,
                                    page: LiveStockPage(
                                      farmId: farmId!,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.paw),
                                SizedBox(width: 15),
                                Text(
                                  "Vật nuôi",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisibleLiveStock = !isVisibleLiveStock;
                                isVisiblePlant = false;
                              });
                            },
                            icon: Icon(FontAwesomeIcons.chevronDown, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: isVisibleLiveStock
                        ? BoxDecoration(
                            border: Border(
                                top: BorderSide(
                              color: Colors.grey,
                            )),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // Màu của bóng
                                offset: Offset(0, 1),
                                blurRadius: 1.0,
                                spreadRadius: 1, // Độ mờ của bóng
                              ),
                            ],
                          )
                        : BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.white10))),
                  ),
                ]),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isVisibleLiveStock ? 100 : 0,
                  child: Visibility(
                    visible: isVisibleLiveStock,
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      padding: EdgeInsets.only(top: 8, left: 56, bottom: 20),
                      color: Colors.grey[300],
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavBar(
                                        farmId: farmId!,
                                        index: 0,
                                        page:
                                            LiveStockFieldPage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Chuồng",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavBar(
                                        farmId: farmId!,
                                        index: 0,
                                        page:
                                            LiveStockTypePage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Loại vật nuôi",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: padingForAll - 9,
                      left: padingForAll,
                      right: padingForAll,
                    ),
                    color: isVisiblePlant ? Colors.grey[300] : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BottomNavBar(
                                    farmId: farmId!,
                                    index: 0,
                                    page: PlantPage(
                                      farmId: farmId!,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.pagelines),
                                SizedBox(width: 15),
                                Text(
                                  "Cây trồng",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisiblePlant = !isVisiblePlant;
                                isVisibleLiveStock = false;
                              });
                            },
                            icon: Icon(FontAwesomeIcons.chevronDown, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: isVisiblePlant
                        ? BoxDecoration(
                            border: Border(
                                top: BorderSide(
                              color: Colors.grey,
                            )),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // Màu của bóng
                                offset: Offset(0,
                                    1), // Điều chỉnh vị trí của bóng theo chiều dọc
                                blurRadius: 1.0,
                                spreadRadius: 1, // Độ mờ của bóng
                              ),
                            ],
                          )
                        : BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.white))),
                  ),
                ]),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isVisiblePlant ? 100 : 0,
                  child: Visibility(
                    visible: isVisiblePlant,
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      padding: EdgeInsets.only(top: 8, left: 56, bottom: 20),
                      color: Colors.grey[300],
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavBar(
                                        farmId: farmId!,
                                        index: 0,
                                        page: PlantFieldPage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Vườn cây",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BottomNavBar(
                                        farmId: farmId!,
                                        index: 0,
                                        page: PlantTypePage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Loại cây",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      EdgeInsets.only(left: padingForAll, right: padingForAll),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                            farmId: farmId!,
                            index: 0,
                            page: EmployeekPage(role: role!),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.people_alt_outlined),
                        SizedBox(width: 15),
                        Text(
                          "Nhân viên",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding:
                      EdgeInsets.only(left: padingForAll, right: padingForAll),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                            farmId: farmId!,
                            index: 0,
                            page: MaterialsPage(farmId: farmId!),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.handyman_outlined),
                        SizedBox(width: 15),
                        Text(
                          "Dụng cụ",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
