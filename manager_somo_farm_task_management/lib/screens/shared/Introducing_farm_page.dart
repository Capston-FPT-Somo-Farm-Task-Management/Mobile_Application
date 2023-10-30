import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/services/farm_service.dart';
import 'package:manager_somo_farm_task_management/widgets/app_bar.dart';

class IntroducingFarmPage extends StatefulWidget {
  final int farmId;

  const IntroducingFarmPage({Key? key, required this.farmId}) : super(key: key);

  @override
  State<IntroducingFarmPage> createState() => _IntroducingFarmPageState();
}

class _IntroducingFarmPageState extends State<IntroducingFarmPage> {
  Future<Map<String, dynamic>> GetFarm(int farmId) {
    return FarmService().getUserById(farmId);
  }

  Future<Map<String, dynamic>>? farmData;

  @override
  void initState() {
    super.initState();
    farmData = GetFarm(widget.farmId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: farmData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Thay bằng tiến trình đang tải dữ liệu
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final farm = snapshot.data as Map<String, dynamic>;

                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 8,
                                  offset: Offset(2, 4), // Shadow position
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 80,
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "",
                                                // farmData['name'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
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
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
