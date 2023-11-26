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
import 'package:manager_somo_farm_task_management/screens/manager/taskType/taskType_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/zone/zone_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/Introducing_farm_page.dart';
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

  bool isVisibleArea = false;

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
                // SizedBox(height: 25),
                // Container(
                //   padding:
                //       EdgeInsets.only(left: padingForAll, right: padingForAll),
                //   child: Align(
                //     alignment: Alignment.centerLeft, // Căn lề trái
                //     child: InkWell(
                //       onTap: () {
                //         Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) => BottomNavBar(
                //             farmId: farmId!,
                //             index: 0,
                //             page: TaskPage(),
                //           ),
                //         ));
                //       },
                //       child: const Row(children: [
                //         Icon(Icons.check_circle),
                //         SizedBox(width: 15),
                //         Text(
                //           "Công việc",
                //           style: TextStyle(fontSize: 21),
                //         ),
                //       ]),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 25),
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
                            page: EmployeekPage(
                              role: role!,
                              viewTime: true,
                            ),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.timer),
                        SizedBox(width: 15),
                        Text(
                          "Thời gian làm việc",
                          style: TextStyle(fontSize: 21),
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
                            page: IntroducingFarmPage(farmId: farmId!),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 15),
                        Text(
                          "Thông tin nông trại",
                          style: TextStyle(fontSize: 21),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
              if (role == "Manager") ...[
                // Container(
                //   padding: EdgeInsets.only(
                //     left: padingForAll,
                //     right: padingForAll,
                //     top: padingForAll,
                //   ),
                //   child: Align(
                //     alignment: Alignment.centerLeft, // Căn lề trái
                //     child: InkWell(
                //       onTap: () {
                //         Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) => BottomNavBar(
                //             farmId: farmId!,
                //             index: 0,
                //             page: TaskPage(),
                //           ),
                //         ));
                //       },
                //       child: const Row(children: [
                //         Icon(Icons.check_circle),
                //         SizedBox(width: 15),
                //         Text(
                //           "Công việc",
                //           style: TextStyle(fontSize: 20),
                //         ),
                //       ]),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 25),

                // SizedBox(height: 15),
                Stack(children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: padingForAll - 13,
                          left: padingForAll,
                          right: padingForAll,
                          bottom: padingForAll - 13),
                      color: isVisibleArea ? Colors.grey[300] : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.locationDot, size: 23),
                                SizedBox(width: 15),
                                Text(
                                  "Vị trí",
                                  style: TextStyle(fontSize: 21),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisibleArea = !isVisibleArea;
                                  isVisiblePlant = false;
                                  isVisibleLiveStock = false;
                                });
                              },
                              icon: isVisibleArea == false
                                  ? Icon(FontAwesomeIcons.chevronDown, size: 18)
                                  : Icon(FontAwesomeIcons.chevronUp, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isVisibleArea = !isVisibleArea;
                        isVisiblePlant = false;
                        isVisibleLiveStock = false;
                      });
                    },
                  ),
                  // Container(
                  //   decoration: isVisibleArea
                  //       ? BoxDecoration(
                  //           border: Border(
                  //               top: BorderSide(
                  //             color: Colors.grey,
                  //           )),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey, // Màu của bóng
                  //               offset: Offset(0, 1),
                  //               blurRadius: 1.0,
                  //               spreadRadius: 1, // Độ mờ của bóng
                  //             ),
                  //           ],
                  //         )
                  //       : BoxDecoration(
                  //           border: Border(
                  //             top: BorderSide(color: Colors.white10),
                  //           ),
                  //         ),
                  // ),
                ]),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isVisibleArea ? 105 : 0,
                  child: Visibility(
                    visible: isVisibleArea,
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      padding: EdgeInsets.only(top: 15, left: 70, bottom: 20),
                      color: Colors.grey[200],
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
                                        page: AreaPage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Khu vực",
                                    style: TextStyle(fontSize: 19),
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
                                        page: ZonePage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Vùng",
                                    style: TextStyle(fontSize: 19),
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
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: padingForAll - 13,
                          left: padingForAll,
                          right: padingForAll,
                          bottom: padingForAll - 13),
                      color: isVisibleLiveStock ? Colors.grey[300] : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.paw),
                                SizedBox(width: 15),
                                Text(
                                  "Động vật",
                                  style: TextStyle(fontSize: 21),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisibleLiveStock = !isVisibleLiveStock;
                                  isVisiblePlant = false;
                                  isVisibleArea = false;
                                });
                              },
                              icon: isVisibleLiveStock == false
                                  ? Icon(FontAwesomeIcons.chevronDown, size: 18)
                                  : Icon(FontAwesomeIcons.chevronUp, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isVisibleLiveStock = !isVisibleLiveStock;
                        isVisiblePlant = false;
                        isVisibleArea = false;
                      });
                    },
                  ),
                ]),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isVisibleLiveStock ? 143 : 0,
                  child: Visibility(
                    visible: isVisibleLiveStock,
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      padding: EdgeInsets.only(top: 15, left: 70, bottom: 20),
                      color: Colors.grey[200],
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
                                        page: LiveStockPage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                splashColor: Colors.grey,
                                child: Text(
                                  "Vật nuôi",
                                  style: TextStyle(fontSize: 19),
                                ),
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
                                            LiveStockFieldPage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Chuồng",
                                    style: TextStyle(fontSize: 19),
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
                                    style: TextStyle(fontSize: 19),
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
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: padingForAll - 13,
                          left: padingForAll,
                          right: padingForAll,
                          bottom: padingForAll - 13),
                      color: isVisiblePlant ? Colors.grey[300] : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.pagelines),
                                SizedBox(width: 15),
                                Text(
                                  "Thực vật",
                                  style: TextStyle(fontSize: 21),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisiblePlant = !isVisiblePlant;
                                  isVisibleLiveStock = false;
                                  isVisibleArea = false;
                                });
                              },
                              icon: isVisiblePlant == false
                                  ? Icon(FontAwesomeIcons.chevronDown, size: 18)
                                  : Icon(FontAwesomeIcons.chevronUp, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isVisiblePlant = !isVisiblePlant;
                        isVisibleLiveStock = false;
                        isVisibleArea = false;
                      });
                    },
                  ),
                  // Container(
                  //   decoration: isVisiblePlant
                  //       ? BoxDecoration(
                  //           border: Border(
                  //               top: BorderSide(
                  //             color: Colors.grey,
                  //           )),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey, // Màu của bóng
                  //               offset: Offset(0,
                  //                   1), // Điều chỉnh vị trí của bóng theo chiều dọc
                  //               blurRadius: 1.0,
                  //               spreadRadius: 1, // Độ mờ của bóng
                  //             ),
                  //           ],
                  //         )
                  //       : BoxDecoration(
                  //           border:
                  //               Border(top: BorderSide(color: Colors.white))),
                  // ),
                ]),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isVisiblePlant ? 150 : 0,
                  child: Visibility(
                    visible: isVisiblePlant,
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      padding: EdgeInsets.only(top: 15, left: 70, bottom: 20),
                      color: Colors.grey[200],
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
                                        page: PlantPage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Cây trồng",
                                    style: TextStyle(fontSize: 19),
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
                                        page: PlantFieldPage(farmId: farmId!),
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(children: [
                                  Text(
                                    "Vườn cây",
                                    style: TextStyle(fontSize: 19),
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
                                    style: TextStyle(fontSize: 19),
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
                const SizedBox(height: 15),
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
                            page: EmployeekPage(
                              role: role!,
                              viewTime: false,
                            ),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.people_alt_outlined),
                        SizedBox(width: 15),
                        Text(
                          "Nhân viên",
                          style: TextStyle(fontSize: 21),
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
                            page: TaskTypePage(),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.list, size: 25),
                        SizedBox(width: 15),
                        Text(
                          "Loại công việc",
                          style: TextStyle(fontSize: 21),
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
                          style: TextStyle(fontSize: 21),
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
                            page: IntroducingFarmPage(farmId: farmId!),
                          ),
                        ));
                      },
                      child: const Row(children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 15),
                        Text(
                          "Thông tin nông trại",
                          style: TextStyle(fontSize: 21),
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
