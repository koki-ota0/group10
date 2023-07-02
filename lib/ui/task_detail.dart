import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dunjion_app/ui/Dungeon.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({super.key, required this.id});
  int id;
  @override
  // ignore: library_private_types_in_public_api
  State<TaskDetail> createState() => _TaskDetailState();
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
        //backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder(
        future: getQuest(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Column(children: [
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
            ]));
          } else {
            return const Text('Loading...');
          }
        },
      ),
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}
