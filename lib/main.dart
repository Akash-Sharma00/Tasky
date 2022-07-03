import 'package:flutter/material.dart';
import 'package:todo_list/resources/savedata.dart';

import 'resources/create_notification.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasky',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List tasks = [];
  List status = [];
  List selectedDate = [];
  String buttonText = 'Set Remaider';
  TextEditingController taskData = TextEditingController();

  @override
  void initState() {
    gettingData();
    CreateNotificataion().init();
    super.initState();
  }

  gettingData() async {
    status = await StoreData().getAllData('status');
    tasks = await StoreData().getAllData('tasky');
    selectedDate = await StoreData().getAllData('remainder');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> pickDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100));

      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          String date = DateTime.utc(picked.year, picked.month, picked.day,
                  time!.hour, time.minute)
              .toString();
          selectedDate.insert(0, date);
        });
      }
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[150],
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tasky'),
                IconButton(
                    onPressed: () {
                      setState(
                        () {
                          tasks.clear();
                          selectedDate.clear();
                          status.clear();
                          StoreData().deleteDataAll();
                        },
                      );
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
          ),
          body: tasks.isEmpty
              ? const Center(
                  child: Text("No Task Were Created"),
                )
              : ReorderableListView(
                  children: <Widget>[
                    for (int index = 0; index < tasks.length; index += 1)
                      Container(
                        key: Key('$index'),
                        alignment: Alignment.center,
                        height: 70,
                        margin: const EdgeInsets.only(
                            bottom: 5, left: 10, right: 10),
                        child: taskTile(index),
                      ),
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final String item = tasks.removeAt(oldIndex);
                      tasks.insert(newIndex, item);
                      final bool itemCheck = status.removeAt(oldIndex);
                      status.insert(newIndex, itemCheck);
                      final String dateCheck = selectedDate.removeAt(oldIndex);
                      selectedDate.insert(newIndex, dateCheck);
                      StoreData().saveAllData(tasks, status, selectedDate);
                    });
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskData,
                      decoration: const InputDecoration(hintText: "Enter Task"),
                    ),
                    TextButton(
                        onPressed: () => pickDate(context),
                        child: Text(buttonText))
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tasks.insert(0, taskData.text);
                        status.insert(0, false);
                        if (selectedDate.length < tasks.length) {
                          setState(() {
                            selectedDate.insert(0, "not Given");
                          });
                        }
                        StoreData().saveAllData(tasks, status, selectedDate);
                      });
                      Navigator.pop(context, 'Done');
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            child: const Icon(Icons.add),
          )),
    );
  }

  ListTile taskTile(int index) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tileColor: Colors.white,
      leading: Checkbox(
          value: status[index],
          onChanged: (bool? v) {
            setState(() {
              status[index] = v!;
              int oldIndex = index;
              int newIndex = status.length - 1;
              if (status[index] == true) {
                // newIndex -= 1;
                final String item = tasks.removeAt(oldIndex);
                tasks.insert(newIndex, item);
                final bool itemCheck = status.removeAt(oldIndex);
                status.insert(newIndex, itemCheck);
                final String dateCheck = selectedDate.removeAt(oldIndex);
                selectedDate.insert(newIndex, dateCheck);
                StoreData().saveAllData(tasks, status, selectedDate);
              }
            });
          }),
      title: Text(
        tasks[index],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: timeStamp(index),
      trailing: delButton(index),
    );
  }

  Padding delButton(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundColor: Colors.red,
        child: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              tasks.removeAt(index);
              status.removeAt(index);
              selectedDate.removeAt(index);
              StoreData().saveAllData(tasks, status, selectedDate);
            });
          },
        ),
      ),
    );
  }

  Widget timeStamp(int index) {
    // int year = int.parse(selectedDate[index].substring(0, 4));
    // int month = int.parse(selectedDate[index].substring(5, 7));
    // int date = int.parse(selectedDate[index].substring(8, 10));
    // int hour = int.parse(selectedDate[index].substring(11, 13));
    // int min = int.parse(selectedDate[index].substring(14, 16));
    // List<DateTime> d = [
    //   DateTime.utc(year, month, date, hour, min),
    // ];
    return InkWell(
      onTap: () => {
        setState(() {
          // ScaffoldMessenger.of(context)
          // .showSnackBar(SnackBar(content: Text(d[0].toString())));
        }),
      },
      child: Visibility(
        visible: !selectedDate[index].toString().contains('not Given'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.alarm,
              color: Colors.red,
              size: 14,
            ),
            selectedDate[index].contains('not Given')
                ? const Text("")
                : Text(
                    (selectedDate[index].substring(5, 16)),
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }
}
