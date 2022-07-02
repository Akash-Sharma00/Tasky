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



















// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// class Savedata {
//   List<String> task, remainder;
//   List<bool> status;

//   Savedata(this.task, this.remainder, this.status);

//   Map toMap() {
//     Map<String, List<dynamic>> m1 = {
//       'task': task,
//       'remaider': remainder,
//       'status': status
//     };
//     return m1;
//   }

//   saveLocal()async{
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String data = toMap().toString();
//     print(data);
//     String s = json.encode(data);
//     print(s);

//     pref.setString('data', s);

//     print(pref.getString('data'));
// String? x = pref.getString('data');
// print(x);

//    Map<String,dynamic> a = await json.decode(x!);
//     print(a);


//   }

  // Savedata.fromMap(Map map):
  //   this.task =   map['task'],
  //   this.status = map['status'],
  //   this.remainder = map['remainder'];

  //   Map toMap(){
  //     return{
  //       'task':this.task,
  //       'status':this.status,
  //       'remaider':this.remainder,
  //     };
  //   }

// }
