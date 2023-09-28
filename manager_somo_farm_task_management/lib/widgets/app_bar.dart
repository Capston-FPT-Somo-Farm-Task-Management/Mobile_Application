import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/manager/animal/livestock_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plant_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task/task_page.dart';
import 'package:manager_somo_farm_task_management/screens/other/login_page.dart';

import '../screens/manager/farm_list_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80 * 2),
      child: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 4,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const FarmListPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (BuildContext context) {
                              return Container(
                                height: MediaQuery.of(context).size.height *
                                    0.8, // Điều chỉnh chiều cao tối đa của bottom sheet
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16.0),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment
                                                .centerLeft, // Căn lề trái
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Row(children: [
                                                Icon(Icons.check_circle),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Task",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment
                                                .centerLeft, // Căn lề trái
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Row(children: [
                                                Icon(Icons.note_add),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Note",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.add_circle,
                          size: 30,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (BuildContext context) {
                              return Container(
                                height: MediaQuery.of(context).size.height *
                                    0.8, // Điều chỉnh chiều cao tối đa của bottom sheet
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16.0),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment
                                                .centerLeft, // Căn lề trái
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TaskPage(),
                                                ));
                                              },
                                              child: const Row(children: [
                                                Icon(Icons.check_circle),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Công việc",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment
                                                .centerLeft, // Căn lề trái
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Row(children: [
                                                Icon(Icons.map),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Trang trại",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment
                                                .centerLeft, // Căn lề trái
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Row(children: [
                                                Icon(Icons.pie_chart_rounded),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Báo cáo",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      LiveStockPage(),
                                                ));
                                              },
                                              child: const Row(children: [
                                                Icon(FontAwesomeIcons.hippo),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Động vật",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlantPage(),
                                                ));
                                              },
                                              child: const Row(children: [
                                                Icon(
                                                    FontAwesomeIcons.pagelines),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Thực vật",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Row(children: [
                                                Icon(Icons.person),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Cá nhân",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () {},
                                              child: const Row(children: [
                                                Icon(Icons
                                                    .question_mark_rounded),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Thắc mắc",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage()),
                                                );
                                              },
                                              child: const Row(children: [
                                                Icon(Icons.logout),
                                                SizedBox(width: 15),
                                                Text(
                                                  "Đăng xuất",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.menu,
                              size: 35,
                              color: kTextBlackColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
