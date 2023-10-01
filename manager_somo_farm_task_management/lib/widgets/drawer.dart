import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestock_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plant_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task/task_page.dart';
import 'package:manager_somo_farm_task_management/screens/other/login_page.dart';

class DrawerManager extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  DrawerManager({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft, // Căn lề trái
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TaskPage(),
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
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft, // Căn lề trái
              child: InkWell(
                onTap: () {},
                child: const Row(children: [
                  Icon(Icons.map),
                  SizedBox(width: 15),
                  Text(
                    "Trang trại",
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft, // Căn lề trái
              child: InkWell(
                onTap: () {},
                child: const Row(children: [
                  Icon(Icons.pie_chart_rounded),
                  SizedBox(width: 15),
                  Text(
                    "Báo cáo",
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LiveStockPage(),
                  ));
                },
                child: const Row(children: [
                  Icon(FontAwesomeIcons.hippo),
                  SizedBox(width: 15),
                  Text(
                    "Động vật",
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlantPage(),
                  ));
                },
                child: const Row(children: [
                  Icon(FontAwesomeIcons.pagelines),
                  SizedBox(width: 15),
                  Text(
                    "Thực vật",
                    style: TextStyle(fontSize: 20),
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
                    style: TextStyle(fontSize: 20),
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
                  Icon(Icons.question_mark_rounded),
                  SizedBox(width: 15),
                  Text(
                    "Thắc mắc",
                    style: TextStyle(fontSize: 20),
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
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Row(children: [
                  Icon(Icons.logout),
                  SizedBox(width: 15),
                  Text(
                    "Đăng xuất",
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
