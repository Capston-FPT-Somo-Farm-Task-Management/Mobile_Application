import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class SnackbarShowNoti {
  static void showSnackbar(String message, bool isWarning) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[100],
      textColor: isWarning ? Colors.red : kPrimaryColor,
      fontSize: 15.0,
      webBgColor: "linear-gradient(to right, $kPrimaryColor, ${Colors.white})",
    );
  }
}
