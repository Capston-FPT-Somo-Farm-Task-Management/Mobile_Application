import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/services/google_authentication_service.dart';

import '../../widgets/bottom_navigation_bar.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Settings',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    // TODO: Implement profile settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Privacy'),
                  onTap: () {
                    // TODO: Implement privacy settings
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'General Settings',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () {
                    // TODO: Implement notification settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  onTap: () {
                    // TODO: Implement language settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.output_outlined),
                  title: const Text('Log out'),
                  onTap: () {
                    // Điều hướng đến trang LoginPage
                    AuthService().logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTabChanged: (index) {},
      ),
    );
  }
}
