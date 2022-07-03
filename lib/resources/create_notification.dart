import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CreateNotificataion {
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  void init() {
    var androidInitilize = const AndroidInitializationSettings("app_icon");
    var iosInitilize = const IOSInitializationSettings();
    var initilizationSetting =
        InitializationSettings(android: androidInitilize, iOS: iosInitilize);

    plugin.initialize(initilizationSetting,
        onSelectNotification: notificationSelected);
  }

  Future showNotification() async {
    var androidDetail = const AndroidNotificationDetails("Channel Id", "Akash",
        importance: Importance.max);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetail =
        NotificationDetails(android: androidDetail, iOS: iosDetails);

    await plugin.show(0, "Akash", "There We go", generalNotificationDetail);
  }

  Future notificationSelected(String? payload) async {
    
  }
}
