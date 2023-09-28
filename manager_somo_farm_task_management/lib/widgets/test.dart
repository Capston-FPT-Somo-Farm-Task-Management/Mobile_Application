import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/widgets/app_bar.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Text("sssss"),
      ),
      body: Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      appBar: const PreferredSize(
        preferredSize:
            Size.fromHeight(BouncingScrollSimulation.maxSpringTransferVelocity),
        child: CustomAppBar(),
      ),
    );
  }
}
