import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;

  String? newTaskContent;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    // print("Input value: $newTaskContent");

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.1, // Adjust as necessary
        title: const Text("Taskly"),
        titleTextStyle: const TextStyle(
          fontSize: 25,
        ),
        centerTitle: false,
      ),
      body: taskView(),
      floatingActionButton: _addButtonAction(context),
    );
  }

  Widget taskView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _taskList();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _taskList() {
    // Task newTask = Task(content: "Eat Pizza", timestamp: DateTime.now(), done: false);
    // _box?.add(newTask.toMap());
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        //formap will take a map
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              fontSize: 20,
              decoration: task.done
                  ? TextDecoration.lineThrough
                  : null, // Strike-through effect
            ),
          ),
          subtitle:
              Text(task.timestamp.toString()), // Show current date and time
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: const Color.fromARGB(255, 0, 20, 76),
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(
              index,
              task.toMap(),
            );
            setState(() {});
          },
          onLongPress: (){
            _box!.deleteAt(index);
             setState(() {});
          },
        );
      },
    );
  }

  Widget _addButtonAction(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _displayTaskPopUp(),
      child: const Icon(
        Icons.add,
      ),
    );
  }

  void _displayTaskPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext content) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            onSubmitted: (value) {
              if (newTaskContent != null) {
                var task = Task(
                    content: newTaskContent!,
                    timestamp: DateTime.now(),
                    done: false);
                _box!.add(task.toMap());
                setState(() {
                  newTaskContent = null;

                  //close the modal
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (value) {
              setState(() {
                newTaskContent = value;
              });
            },
          ),
        );
      },
    );
  }
}
