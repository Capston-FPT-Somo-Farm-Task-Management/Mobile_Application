import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/services/farm_service.dart';
import 'package:manager_somo_farm_task_management/services/user_services.dart';
import 'package:manager_somo_farm_task_management/widgets/app_bar.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    GetUser(widget.userId).then((value) {
      setState(() {
        userData = value['data'];
      });
    });
  }

  Future<Map<String, dynamic>> GetUser(int userId) {
    return UserService().getUserById(userId);
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
                        userData != null ? userData!['name'] : '',
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
