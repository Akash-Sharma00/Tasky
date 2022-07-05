import 'package:flutter/material.dart';
import 'package:todo_list/resources/savedata.dart';
import 'resources/create_notification.dart';
import 'package:timezone/data/latest.dart' as tz;

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
  List tasks = ['Create Your First Task'];
  List status = [false];
  List selectedDate = ["not Given"];
  String buttonText = 'Set Remaider';
  TextEditingController taskData = TextEditingController();
  late CreateNotificataion c;

  @override
  void initState() {
    gettingData();
    c = CreateNotificataion();
    c.init();
    tz.initializeTimeZones();
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
                      // c.showShechduleNotification();
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
                        child: status[index]
                            ? completedTaskTile(index)
                            : taskTile(index),
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
                        } else {
                          notificationTime(selectedDate[0], tasks[0],
                              "Your Pending Tasks", selectedDate.length);
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
      leading: checkTaskStatus(index),
      title: Text(
        tasks[index],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: timeStamp(index),
      trailing: delButton(index, Colors.red),
    );
  }

  Padding delButton(int index, Color c) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundColor: c,
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
    return InkWell(
      onTap: () => {
        setState(() {
          // notificationTime(selectedDate[index]);
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

  void notificationTime(
      String selectedDate, String title, String body, int id) {
    int year = int.parse(selectedDate.substring(0, 4));
    int month = int.parse(selectedDate.substring(5, 7));
    int date = int.parse(selectedDate.substring(8, 10));
    int hour = int.parse(selectedDate.substring(11, 13));
    int min = int.parse(selectedDate.substring(14, 16));
    DateTime d = DateTime.utc(year, month, date, hour, min);
    c.showShechduleNotification(d, title, body, id);
  }

  completedTaskTile(int index) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tileColor: Colors.white,
      leading: checkTaskStatus(index),
      title: Text(
        tasks[index],
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
      ),
      subtitle: const Text(
        "🎉Completed🎉",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
      trailing: delButton(index, Colors.grey),
    );
  }

  Checkbox checkTaskStatus(int index) {
    return Checkbox(
        value: status[index],
        onChanged: (bool? v) {
          setState(() {
            status[index] = v!;
            int oldIndex = index;
            int newIndex = status.length - 1;
            if (status[index] == true) {
              final String item = tasks.removeAt(oldIndex);
              tasks.insert(newIndex, item);
              final bool itemCheck = status.removeAt(oldIndex);
              status.insert(newIndex, itemCheck);
              final String dateCheck = selectedDate.removeAt(oldIndex);
              selectedDate.insert(newIndex, dateCheck);
              StoreData().saveAllData(tasks, status, selectedDate);
            } else {
              final String item = tasks.removeAt(oldIndex);
              tasks.insert(0, item);
              final bool itemCheck = status.removeAt(oldIndex);
              status.insert(0, itemCheck);
              final String dateCheck = selectedDate.removeAt(oldIndex);
              selectedDate.insert(0, dateCheck);
              StoreData().saveAllData(tasks, status, selectedDate);
            }
          });
        });
  }
}
