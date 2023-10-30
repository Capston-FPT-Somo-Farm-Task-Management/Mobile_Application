import 'package:flutter/material.dart';
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
    final data = await GetFarm(widget.farmId);
    setState(() {
      farmData = data;
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
        padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        farmData != null ? farmData!['name'] : '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
