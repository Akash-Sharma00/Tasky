import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/browser.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class CreateNotificataion {
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  void init() {
    tz.initializeTimeZones();
    var androidInitilize =
        const AndroidInitializationSettings('@drawable/app_icon');
    var iosInitilize = const IOSInitializationSettings();
    var initilizationSetting =
        InitializationSettings(android: androidInitilize, iOS: iosInitilize);

    plugin.initialize(initilizationSetting,
        onSelectNotification: notificationSelected);
  }

  Future showNotification() async {
    var androidDetail = const AndroidNotificationDetails("Channel Id", "Akash",
        importance: Importance.max, priority: Priority.max, playSound: true);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetail =
        NotificationDetails(android: androidDetail, iOS: iosDetails);

    await plugin.show(0, "Akash", "There We go", generalNotificationDetail);
  }

  Future showShechduleNotification(int year, int month, int day, int hour,
      int minutes, String title, String body, int id) async {
    var androidDetail = const AndroidNotificationDetails("Channel Id", "Akash",
        importance: Importance.max, priority: Priority.max, playSound: true);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetail =
        NotificationDetails(android: androidDetail, iOS: iosDetails);

    await plugin.zonedSchedule(
        0,
        title,
        body,
        // _convertTime(year, month, day, hour, minutes),
        TZDateTime.from(DateTime.now().add(Duration(days: DateTime.now().day - day,hours: 0,minutes: minutes)), local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id ',
            'your channel name',
            channelDescription: 'your channel description',
            autoCancel: false,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: IOSNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    // _convertTime(year, month, day, hour, minutes);
  }

  TZDateTime _convertTime(int year, int month, int day, int hour, int minutes) {
    // final TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduleDate = TZDateTime(
      local,
      year,
      month,
      day,
      hour,
      minutes,
    );
    // if (scheduleDate.isBefore(now)) {
    //   scheduleDate = scheduleDate.add(const Duration(days: 1));
    // }
    print(scheduleDate);
    return scheduleDate;
  }


  Future notificationSelected(String? payload) async {}
}
