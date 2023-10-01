import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:manager_somo_farm_task_management/models/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('appicon');
  void initialNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  void sendNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.max,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'this is title',
      'description',
      notificationDetails,
    );
  }

  void scheduleNotification(Map<String, dynamic> task) async {
    try {
      AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.max,
        priority: Priority.max,
      );
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      tz.TZDateTime notificationTime = tz.TZDateTime.from(
        DateTime.parse(task['startDate'])
            .subtract(Duration(minutes: task['remind'])),
        tz.local,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        task['id'],
        task['name'],
        'Bắt đầu trong ${task['remind']} phút nữa!',
        notificationTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
