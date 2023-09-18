import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/farm.dart';
import 'package:manager_somo_farm_task_management/screens/manager/add_task/first_add_task_page.dart';

class ChooseHabitantPage extends StatefulWidget {
  final Farm farm;

  const ChooseHabitantPage({super.key, required this.farm});
  @override
  _ChooseHabitantPageState createState() => _ChooseHabitantPageState();
}

class _ChooseHabitantPageState extends State<ChooseHabitantPage> {
  bool remindMe = true;

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
              "Công việc dành cho:",
              style: headingStyle,
            ),
            const Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FirstAddTaskPage(farm: widget.farm),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kTextGreyColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ///Container for Icon
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 246, 255, 246)),
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.pets_outlined,
                        color: kPrimaryColor,
                      ),
                    ),

                    ///For spacing
                    const SizedBox(
                      width: 24,
                    ),

                    ///For Text
                    const Text(
                      "Động vật",
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: kTextGreyColor),
                    ),

                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),

            ///For Spacing
            const SizedBox(height: 16),

            ///Container for remind
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: kTextGreyColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ///Container for Icon
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 246, 255, 246)),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      FontAwesomeIcons.pagelines,
                      color: kPrimaryColor,
                    ),
                  ),

                  ///For spacing
                  const SizedBox(
                    width: 24,
                  ),

                  ///For Text
                  const Text(
                    "Thực vật",
                    style: TextStyle(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: kTextGreyColor),
                  ),

                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            ///Container for remind
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: kTextGreyColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ///Container for Icon
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 245, 243, 241)),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.help,
                      color: kSecondColor,
                    ),
                  ),

                  ///For spacing
                  const SizedBox(
                    width: 24,
                  ),

                  ///For Text
                  const Text(
                    "Khác",
                    style: TextStyle(
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: kTextGreyColor),
                  ),

                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
