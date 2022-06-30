import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  final List<String> tasks = [];
  final List<bool> status = [];
  final List<DateTime> selectedDate = [];
  String buttonText = 'Set Remaider';
  TextEditingController taskData = TextEditingController();

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
          selectedDate.insert(
              0,
              DateTime.utc(picked.year, picked.month, picked.day, time!.hour,
                  time.minute));
        });
      }
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[150],
          appBar: AppBar(
            title: const Text('Tasky'),
          ),
          body: tasks.isEmpty
              ? const Center(
                  child: Text("No Task Were Created"),
                )
              : ReorderableListView(
                  children: <Widget>[
                    for (int index = 0; index < tasks.length; index += 1)
                      Container(
                        alignment: Alignment.center,
                        height: 70,
                        margin: const EdgeInsets.only(
                            bottom: 5, left: 10, right: 10),
                        key: Key("$index "),
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
                      final DateTime dateCheck =
                          selectedDate.removeAt(oldIndex);
                      selectedDate.insert(newIndex, dateCheck);
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
                      });
                      if (selectedDate.length < tasks.length) {
                        setState(() {
                          selectedDate.insert(0, DateTime(0));
                        });
                      }
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
            });
          }),
      title: Text(
        tasks[index],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: timeStamp(index),
      trailing: CircleAvatar(
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
            });
          },
        ),
      ),
    );
  }

  Widget timeStamp(int index) {
    return InkWell(
      onTap: () => setState(() {}),
      child: Visibility(
        visible: selectedDate[index].hour != 0,
        child: Row(
          children: [
            const Icon(
              Icons.alarm,
              color: Colors.red,
              size: 14,
            ),
            Text(
              ("${selectedDate[index].day}/${selectedDate[index].month} ${selectedDate[index].hour}:${selectedDate[index].minute}"),
              style: const TextStyle(
                  color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
