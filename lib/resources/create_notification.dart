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

  // fuction for schedule notification:

  Future showShechduleNotification(
    DateTime nTime,
    String title,
    String body,
    int id,
  ) async {
    const sound = 'notification_sound.mp3';
    TZDateTime dt = TZDateTime.now(local).add(const Duration(minutes: 2));

    await plugin.zonedSchedule(
        id,
        title,
        body,
        dt,
        // _convertTime(Time(nTime.hour, nTime.minute), nTime),
        NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel $id ', 'your channel name',
              channelDescription: 'your channel description',
              autoCancel: true,
              importance: Importance.max,
              priority: Priority.high,
              sound:
                  RawResourceAndroidNotificationSound(sound.split('.').first),
              enableLights: true),
          iOS: const IOSNotificationDetails(sound: sound),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
    // _convertTime(year, month, day, hour, minutes);
  }

  TZDateTime _convertTime(Time time, DateTime t) {
    final TZDateTime now =
        TZDateTime.now(local).add(const Duration(seconds: 10));
    TZDateTime scheduleDate = TZDateTime(
      local,
      t.year,
      t.month,
      t.day,
      time.hour,
      time.minute,
      time.second,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future notificationSelected(String? payload) async {}

  //function for quick notification:

  // Future showNotification(
  //     DateTime nTime, String title, String body, int id) async {
  //   var androidDetail = const AndroidNotificationDetails(
  //     "Channel Id",
  //     "Akash",
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     sound: RawResourceAndroidNotificationSound('@raw/notification_sound'),
  //   );
  //   var iosDetails = const IOSNotificationDetails();
  //   var generalNotificationDetail =
  //       NotificationDetails(android: androidDetail, iOS: iosDetails);

  //   await plugin.show(0, "Akash", "There We go", generalNotificationDetail);
  // }

}
