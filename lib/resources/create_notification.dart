import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  Future showNotification(
      DateTime nTime, String title, String body, int id) async {
    var androidDetail = const AndroidNotificationDetails(
      "Channel Id",
      "Akash",
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('@raw/notification_sound'),
    );
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetail =
        NotificationDetails(android: androidDetail, iOS: iosDetails);

    await plugin.show(0, "Akash", "There We go", generalNotificationDetail);
  }

  Future showShechduleNotification(
      DateTime nTime, String title, String body, int id) async {
    const sound = 'notification_sound.wav';
    // TZDateTime dt = nTime as TZDateTime;
    // var androidDetail = const AndroidNotificationDetails(
    //     "Channel Id",
    //     "Akash",
    //     importance: Importance.max,
    //     priority: Priority.max,
    //     );
    // var iosDetails = const IOSNotificationDetails(sound: 'notification_sound');
    // var generalNotificationDetail =
    //     NotificationDetails(android: androidDetail, iOS: iosDetails);

    await plugin.zonedSchedule(
        id,
        title,
        body,
        // _convertTime(nTime.year,nTime.month,nTime.day,nTime.hour,nTime.minute),
        // TZDateTime.from(nTime, local),
        TZDateTime(local, 2022, 7, 5, 9, 26),
        // TZDateTime.local(
        //     nTime.year, nTime.month, nTime.day, nTime.hour, nTime.minute),
        // TZDateTime.utc(
        //         nTime.year, nTime.month, nTime.day, nTime.hour, nTime.minute)
        //     .add(const Duration(seconds: 5)),
        // TZDateTime(
        //   local,
        //   nTime.year,
        //   nTime.month,
        //   nTime.day,
        //   nTime.hour,
        //   nTime.minute,
        // ),
        NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel $id ', 'your channel name',
              channelDescription: 'your channel description',
              autoCancel: true,
              importance: Importance.max,
              priority: Priority.high,
              color: Colors.red,
              sound:
                  RawResourceAndroidNotificationSound(sound.split('.').first),
              enableLights: true),
          iOS: const IOSNotificationDetails(sound: sound),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    // _convertTime(year, month, day, hour, minutes);
  }

  // TZDateTime _convertTime(int year, int month, int day, int hour, int minutes) {
  //   final TZDateTime now = TZDateTime.now(local);
  //   TZDateTime scheduleDate = TZDateTime(
  //     local,
  //     year,
  //     month,
  //     day,
  //     hour,
  //     minutes,
  //   );
  //   if (scheduleDate.isBefore(now)) {
  //     scheduleDate = scheduleDate.add(const Duration(days: 1));
  //   }
  //   print(scheduleDate);
  //   return scheduleDate;
  // }

  Future notificationSelected(String? payload) async {}
}
