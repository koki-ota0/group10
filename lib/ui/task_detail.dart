import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  double maxHP = 100.0;
  double currentHP = 100.0;

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
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/enemy.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5), // 背景色を設定
                    borderRadius: BorderRadius.circular(8.0), // ボーダーの角丸を設定
                  ),
                  child: LinearProgressIndicator(
                    value: currentHP / maxHP,
                    backgroundColor: Colors.transparent, // 透明にすることで背景色が表示される
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0), // テキストの周囲に余白を追加
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8), // 背景色を設定
                      borderRadius: BorderRadius.circular(8.0), // ボーダーの角丸を設定
                    ),
                    child: Text(
                      'HP: ${currentHP.toInt()}/${maxHP.toInt()}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
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
                  textAlign: TextAlign.center,
                  '締め切り: ${DateFormat('y年M月d日').format(DateTime.parse(task['deadline']))}',
                  style: const TextStyle(
                    fontSize: 20,

                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4, // ボタンの立体感を調整する値
                    minimumSize: Size(150, 50), // ボタンの最小サイズを指定
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dungeon()),
                    );
                  },
                  child: Text('挑戦',
                    style: TextStyle(fontSize: 20),),
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