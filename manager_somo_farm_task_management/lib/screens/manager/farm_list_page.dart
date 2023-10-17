import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/farm.dart';
import '../shared/home/manager_home_page.dart';

class FarmListPage extends StatelessWidget {
  const FarmListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  // Our background
                  Container(
                    margin: const EdgeInsets.only(top: 250),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1EFF1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "Chọn Trang trại cần giao việc:",
                            style: TextStyle(
                              color: kTextWhiteColor,
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 170.0,
                    ),
                    child: ListView.builder(
                        // here we use our demo procuts list
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          EdgeInsetsGeometry margin;
                          if (index == 0) {
                            margin = const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              bottom: 20.0 / 2,
                            );
                          } else {
                            margin = const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 20.0 / 2,
                            );
                          }
                          return Container(
                            margin: margin,
                            height: 160,
                            child: InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManagerHomePage(
                                        farmId: products[index].id),
                                  ),
                                );
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt('farmId', products[index].id);
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  // Those are our background
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: index.isEven
                                          ? kSecondLightColor
                                          : kTextBlueColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 15),
                                          blurRadius: 27,
                                          color: Colors
                                              .black12, // Black color with 12% opacity
                                        )
                                      ],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: kTextWhiteColor,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                    ),
                                  ),
                                  // our product image
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      height: 150,
                                      // image is square but we add extra 20 + 20 padding thats why width is 200
                                      width: 210,
                                      child: Image.network(
                                        products[index].image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  // Product title and price
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: SizedBox(
                                      height: 150,
                                      // our image take 200 width, thats why we set out total width - 200
                                      width: MediaQuery.of(context).size.width -
                                          210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              products[index].title,
                                              style: const TextStyle(
                                                  color: kTextBlackColor),
                                            ),
                                          ),
                                          // it use the available space
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  20 * 1.5, // 30 padding
                                              vertical:
                                                  20 / 4, // 5 top and bottom
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
