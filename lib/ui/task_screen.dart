import 'package:dunjion_app/ui/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dunjion_app/ui/Dungeon.dart';

class Task {
  final String name;
  bool isDone;
  DateTime? deadline;

  Task({this.name = "Task", this.isDone = false, this.deadline});

  void toggleDone() {
    isDone = !isDone;
  }
}

class TaskData extends ChangeNotifier {
  List<Task> tasks = [
    Task(name: 'Task 1'),
    Task(name: 'Task 2'),
    Task(name: 'Task 3'),
  ];
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List quests = [];

  Future getQuests() async {
    var url = Uri.parse('https://bene-hack-api.azurewebsites.net/quest');
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    setState(() {
      quests = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        //backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.builder(
          itemCount: quests.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(quests[index]['name']),
                subtitle: Text(quests[index]['deadline']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TaskDetail(id: quests[index]['id'])),
                  );
                },
              )),
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}
