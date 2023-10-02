import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_add/componets/option.dart';
import 'package:manager_somo_farm_task_management/screens/manager/task_add/first_add_task_page.dart';

class ChooseOneOrMany extends StatefulWidget {
  final int farmId;
  final bool isPlant;
  const ChooseOneOrMany(
      {super.key, required this.farmId, required this.isPlant});
  @override
  _ChooseOneOrManyState createState() => _ChooseOneOrManyState();
}

class _ChooseOneOrManyState extends State<ChooseOneOrMany> {
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
              !widget.isPlant ? "Động vật" : "Thực vật",
              style: headingStyle,
            ),
            const Spacer(),
            !widget.isPlant
                ? Option(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FirstAddTaskPage(
                            farmId: widget.farmId,
                            isOne: true,
                            isPlant: false,
                          ),
                        ),
                      );
                    },
                    title: "Con vật cụ thể",
                    icon: FontAwesomeIcons.hippo,
                    iconColor: kPrimaryColor,
                    backgroundIconColor:
                        const Color.fromARGB(255, 246, 255, 246),
                  )
                : Option(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FirstAddTaskPage(
                            farmId: widget.farmId,
                            isOne: true,
                            isPlant: true,
                          ),
                        ),
                      );
                    },
                    title: "Cây cụ thể",
                    icon: FontAwesomeIcons.leaf,
                    iconColor: kPrimaryColor,
                    backgroundIconColor:
                        const Color.fromARGB(255, 246, 255, 246),
                  ),
            const SizedBox(height: 16),
            !widget.isPlant
                ? Option(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FirstAddTaskPage(
                            farmId: widget.farmId,
                            isOne: false,
                            isPlant: false,
                          ),
                        ),
                      );
                    },
                    title: "Cả chuồng",
                    icon: FontAwesomeIcons.kaaba,
                    iconColor: kPrimaryColor,
                    backgroundIconColor:
                        const Color.fromARGB(255, 246, 255, 246),
                  )
                : Option(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FirstAddTaskPage(
                            farmId: widget.farmId,
                            isOne: false,
                            isPlant: true,
                          ),
                        ),
                      );
                    },
                    title: "Cả vườn",
                    icon: FontAwesomeIcons.kaaba,
                    iconColor: kPrimaryColor,
                    backgroundIconColor:
                        const Color.fromARGB(255, 246, 255, 246),
                  ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
