import 'package:dunjion_app/ui/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Enemy {
  int hp;
  Enemy({required this.hp});
}

class DungeonPage extends StatefulWidget {
  const DungeonPage({Key? key}) : super(key: key);

  @override
  _DungeonPageState createState() => _DungeonPageState();
}

class _DungeonPageState extends State<DungeonPage> with SingleTickerProviderStateMixin {
  double maxHP = 100.0;
  double currentHP = 100.0;
  Future getQuests() async {
    var url = Uri.parse('https://bene-hack-api.azurewebsites.net/quest/status/hp/0');
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    setState(() {
      currentHP = result;
    });
  }

  bool hasAttacked = false; // Track whether the player has attacked or not
  List<String> messages = []; // List to store received messages
  late AnimationController _animationController; // Animation controller for enemy image animation

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animation duration (adjust as needed)
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void attackEnemy() {
    if (!hasAttacked) {
      setState(() {
        currentHP -= 10.0;
        //hasAttacked = true; // Set the flag to true after the attack
      });
      if (currentHP <= 0) {
        // 敵を倒したときの処理
        _animationController.forward(from: 0.0); // Start the animation
        Future.delayed(const Duration(milliseconds: 2000), () {
          // Delay the navigation to the next screen for 2 seconds (adjust as needed)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VictoryScreen()),
          );
        });
      } else {
        _animationController.forward(from: 0.0); // Start the animation
      }
    }
  }

  List<String> supporters = ['田中健太郎', '岡村穂香', '大槻翼', '野木知優', '林まなみ','藤原拓貴', '谷紘毅', '太田光紀'];
  String selectedSupporter = '';

  void openSupportPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('リマインドする人を選択'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: supporters
                .map(
                  (supporter) => ListTile(
                title: Text(supporter),
                onTap: () {
                  setState(() {
                    selectedSupporter = supporter;
                  });
                  Navigator.pop(context);
                  sendMessageToSupporter(supporter);
                },
              ),
            )
                .toList(),
          ),
        );
      },
    );
  }

  void sendMessageToSupporter(String supporter) {
    String message = ''; // メッセージの内容を格納する変数を初期化

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('メッセージを送る'),
          content: TextField(
            decoration: InputDecoration(
              hintText: '入力...',
            ),
            onChanged: (value) {
              // メッセージの入力内容を変数に格納
              message = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // メッセージの内容を表示
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('報酬'),
                      content: Text('1ポイント獲得'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Send the message to the selected supporter
                            final finalMessage = 'To $supporter : $message';
                            setState(() {
                              messages.add(finalMessage);
                            });
                          },
                          child: Text('閉じる'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('送る'),
            ),
          ],
        );
      },
    );
  }

  void checkMessages() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('メッセージ一覧'),
          content: SingleChildScrollView(
            child: Column(
              children: messages
                  .map(
                    (message) => ListTile(
                  title: Text(message),
                ),
              )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  void navigateBackToTaskDetail() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int remainingDays = 1; // Placeholder value for remaining days

    return Scaffold(
      appBar: AppBar(
        title: Text('ダンジョン'),
        actions: [

          IconButton(
            icon: Icon(Icons.message),
            onPressed: checkMessages,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: navigateBackToTaskDetail,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 16.0, // 上部からの位置調整
            right: 16.0, // 右側からの位置調整
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '残り $remainingDays 日',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 100.0),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_animationController.value * 0.2), // Scale the image during animation
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'images/enemy.png',
                      width: 300.0 - (remainingDays * 30),
                      height: 300.0 - (remainingDays * 30),
                      // color: Colors.blueGrey.withOpacity(0.5 - (currentHP / maxHP / 2)),
                      // colorBlendMode: BlendMode.srcATop,
                    ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: hasAttacked ? null : attackEnemy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasAttacked ? Colors.grey : null,
                    ),
                    child: Text('提出'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      openSupportPopup(context);
                    },
                    child: Text('応援'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Dungeon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dungeon Progress',
      theme: ThemeData(),
      home: DungeonPage(),
    );

  }
}

class VictoryScreen extends StatelessWidget {
  final List<String> ranking = [
    '田中健太郎',
    '岡村穂香',
    '大槻翼',
    '野木知優',
    '林まなみ',
    '藤原拓貴',
    '谷紘毅',
    '太田光紀',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Victory'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/victory_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.thumb_up,
                  size: 80,
                  color: Colors.green,
                ),
                SizedBox(height: 16.0),
                Text(
                  'ダンジョン攻略!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    children: [
                      Text(
                        'ランキング:',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      for (var i = 0; i < 5; i++)
                        Text(
                          '${i + 1}位：${ranking[i]}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Image.asset(
                  'images/victory.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskScreen()),
                    );
                  },
                  child: Text('課題一覧に戻る'),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
