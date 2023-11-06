import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFarmData();
  }

  Future<void> _loadFarmData() async {
    GetFarm(widget.farmId).then((value) {
      setState(() {
        farmData = value;
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Container(
                width: 500,
                height: 200,
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
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          wrapWords(
                              farmData != null ? farmData!['address'] : '', 45),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          wrapWords(
                              farmData != null ? farmData!['description'] : '',
                              38),
                          style: const TextStyle(
                            fontSize: 20,
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
    );
  }
}
