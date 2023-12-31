import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/add_task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/choose_one_or_many.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/componets/option.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/first_add_task_other_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseHabitantPage extends StatefulWidget {
  final int farmId;

  const ChooseHabitantPage({super.key, required this.farmId});
  @override
  _ChooseHabitantPageState createState() => _ChooseHabitantPageState();
}

class _ChooseHabitantPageState extends State<ChooseHabitantPage> {
  String? role;
  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleStored = prefs.getString('role');
    setState(() {
      role = roleStored;
    });
  }

  @override
  void initState() {
    super.initState();
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: kSecondColor,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Loại công việc:",
              style: headingStyle,
            ),
            const Spacer(),
            Option(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChooseOneOrMany(
                        farmId: widget.farmId, isPlant: false, role: role!),
                  ),
                );
              },
              title: "Vật nuôi",
              icon: Icons.pets_outlined,
              iconColor: kPrimaryColor,
              backgroundIconColor: const Color.fromARGB(255, 246, 255, 246),
            ),

            ///For Spacing
            const SizedBox(height: 16),

            Option(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChooseOneOrMany(
                        farmId: widget.farmId, isPlant: true, role: role!),
                  ),
                );
              },
              title: "Cây trồng",
              icon: FontAwesomeIcons.pagelines,
              iconColor: kPrimaryColor,
              backgroundIconColor: const Color.fromARGB(255, 246, 255, 246),
            ),
            const SizedBox(height: 16),

            Option(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => role == "Manager"
                        ? AddTaskPage(
                            farmId: widget.farmId,
                            isOne: false,
                          )
                        : FirstAddTaskOtherPage(farmId: widget.farmId),
                  ),
                );
              },
              title: "Công việc khác",
              icon: Icons.help,
              iconColor: kSecondColor,
              backgroundIconColor: const Color.fromARGB(255, 246, 255, 246),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
