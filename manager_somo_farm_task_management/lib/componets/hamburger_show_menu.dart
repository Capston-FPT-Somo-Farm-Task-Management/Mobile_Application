import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/widgets/hamburger%20_menu.dart';

class HamburgerMenu {
  static void showReusableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép bottom sheet có thể cuộn
      builder: (context) => Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: ReusableBottomSheet(
          title: 'Reusable Bottom Sheet',
        ),
      ),
    );
  }
}
