import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dunjion_app/ui/Dungeon.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  dynamic task;

  Future<dynamic> getQuest() async {
    print("id: ${widget.id}");
    var raw_url = 'https://bene-hack-api.azurewebsites.net/quest/${widget.id}';
    var url = Uri.parse(raw_url);
    print(url);
    var response = await http.get(url);
    print(response.statusCode);
    var result = jsonDecode(response.body);
    print('result: ${result}');
    setState(() {
      task = result;
    });
    return result;
  }

  @override
  void initState() {
    super.initState();
    getQuest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '残りの日数: ${task['remainingDays']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getQuest(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/enemy.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  '${task['name']}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'しめきり: ${task['deadline']}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dungeon()),
                    );
                  },
                  child: Text('挑戦'),
                ),
              ],
            );
          } else {
            return const Text('Loading...');
          }
        },
      ),
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}
