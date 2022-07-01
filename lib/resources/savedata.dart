import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StoreData {
  SharedPreferences? pref;
  late Map<String, dynamic> dataSet;

  Future<void> saveAllData(List<String> task, List<bool> taskStatus,
      List<DateTime> remainder) async {
    pref = await SharedPreferences.getInstance();

    dataSet = {'tasky': task, 'status': taskStatus, 'remainder': remainder};
    String rawData = jsonEncode(dataSet);
    pref!.setString("key", rawData);
  }

  Future<Map> getAllData(String key) async {
    pref = await SharedPreferences.getInstance();
    final String? rawJson = pref!.getString('key');
    Map<String, dynamic> map = await jsonDecode(rawJson!);
    return map[key];
  }
}
