import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';
import 'package:manager_somo_farm_task_management/services/farm_service.dart';
import 'package:manager_somo_farm_task_management/widgets/app_bar.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: SingleChildScrollView(
            child: Expanded(
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
                              Container(
                                width: 500,
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.network(
                                  '${farmData != null ? farmData!['urlImage'] : ''}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        farmData != null
                                            ? farmData!['name']
                                            : '',
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
      ),
    );
  }
}
