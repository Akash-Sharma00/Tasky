import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StoreData {
  SharedPreferences? pref;
  late Map<String, List> dataSet;

  Future<void> saveAllData(List task, List taskStatus, List remainder) async {
    pref = await SharedPreferences.getInstance();
    dataSet = {'tasky': task, 'status': taskStatus, 'remainder': remainder};
    String rawData = jsonEncode(dataSet);
    pref!.setString("key", rawData);
  }

  Future<List<dynamic>> getAllData(String key) async {
    pref = await SharedPreferences.getInstance();
    final String? rawJson = pref!.getString('key');
    Map<String, dynamic> map = await jsonDecode(rawJson!);
    List l = map[key];
    return l;
  }

  deleteDataAll() async {
    pref = await SharedPreferences.getInstance();
    pref!.clear();
  }
}
