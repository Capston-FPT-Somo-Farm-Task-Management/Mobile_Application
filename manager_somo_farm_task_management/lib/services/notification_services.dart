// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:get/get.dart';
// import 'package:manager_somo_farm_task_management/models/task.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotifyHelper {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   NotifyHelper()
//       : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future initializeNotification() async {
//     _configureLocalTimezone();

//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('appicon');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }

//   Future selectNotification(String? payload) async {
//     if (payload != null) {
//       print('notification payload: $payload');
//     } else {
//       print("Notification Done");
//     }
//     Get.to(() => Container(
//           color: Colors.white,
//         ));
//   }

//   Future displayNotification(
//       {required String title, required String body}) async {
//     print("doing test");
//     // AndroidPlatformChannelSpecifics is deprecated since version 8.0.0
//     // Use NotificationDetails instead
//     const androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'your channel id', 'your channel name',
//         importance: Importance.max, priority: Priority.high);

//     const platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'It could be anything you pass',
//     );
//   }

//   scheduledNotification(int hour, int minutes, Task task) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'scheduled title',
//         'theme changes 5 seconds ago',
//         //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         _convertTime(hour, minutes),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time);
//   }

//   tz.TZDateTime _convertTime(int hour, int minutes) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduleDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
//     if (scheduleDate.isBefore(now)) {
//       scheduleDate = scheduleDate.add(const Duration(days: 1));
//     }
//     return scheduleDate;
//   }

//   Future<void> _configureLocalTimezone() async {
//     tz.initializeTimeZones();
//     final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZone));
//   }
// }
