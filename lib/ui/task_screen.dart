import 'package:dunjion_app/ui/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dunjion_app/ui/Dungeon.dart';
import 'package:intl/intl.dart'; // Add this line

class Task {
  final String name;
  bool isDone;
  DateTime? deadline;

  Task({this.name = "Task", this.isDone = false, this.deadline});

  void toggleDone() {
    isDone = !isDone;
  }
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
      quests.sort((a, b) => DateTime.parse(a['deadline']).compareTo(DateTime.parse(b['deadline'])));
    });
  }

  @override
  void initState() {
    super.initState();
    getQuests();
  }

  Future<void> addQuest() async {
    String? questName;
    DateTime? deadline;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Quest'),
            content: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    questName = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Quest Name',
                  ),
                ),
                ElevatedButton(
                  child: Text('Select Deadline'),
                  onPressed: () async {
                    deadline = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2099, 12, 31),
                    );
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  if (questName != null && deadline != null) {
                    // POSTを入れる
                    var url = Uri.parse(
                        'https://bene-hack-api.azurewebsites.net/quest');
                    var json = jsonEncode({
                      'name': questName,
                      'deadline': deadline!.toIso8601String(),
                      'isFinished': false
                    });
                    http.post(url,
                        body: json,
                        headers: {'Content-Type': 'application/json'});
                    //
                    setState(() {
                      quests.add({
                        'name': questName,
                        'deadline': deadline!.toIso8601String(),
                        'id': quests.length + 1
                      });
                      quests.sort((a, b) => DateTime.parse(a['deadline']).compareTo(DateTime.parse(b['deadline'])));
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
          itemCount: quests.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
            title: Text(quests[index]['name']),
            subtitle: Text(DateFormat('MMMd').format(DateTime.parse(quests[index]['deadline']))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TaskDetail(id: quests[index]['id'])),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: addQuest,
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
    );
  }
}