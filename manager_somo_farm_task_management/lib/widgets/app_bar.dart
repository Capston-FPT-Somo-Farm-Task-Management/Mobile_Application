import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

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
                          // Xử lý hành động khi biểu tượng "add_circle" được nhấp vào
                          // Đặc điểm xử lý ở đây
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
                          // Xử lý hành động khi biểu tượng "menu" được nhấp vào
                          // Đặc điểm xử lý ở đây
                        },
                        child: const Icon(
                          Icons.menu,
                          size: 35,
                          color: kTextBlackColor,
                        ),
                      ),
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
