import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Enemy {
  int hp;
  Enemy({required this.hp});
}

class DungeonPage extends StatefulWidget {
  const DungeonPage({Key? key}) : super(key: key);
  @override
  _DungeonPageState createState() => _DungeonPageState();
}

class _DungeonPageState extends State<DungeonPage> {
  double maxHP = 100.0;
  double currentHP = 100.0;
  bool hasAttacked = false; // Track whether the player has attacked or not

  void attackEnemy() {
    if (!hasAttacked) {
      setState(() {
        currentHP -= 10.0;
        hasAttacked = true; // Set the flag to true after the attack
      });
    }
  }

  Enemy enemy = Enemy(hp: 100);
  List<String> supporters = ['Supporter A', 'Supporter B', 'Supporter C'];
  String selectedSupporter = '';

  void openSupportPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Supporter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: supporters
                .map((supporter) => ListTile(
                      title: Text(supporter),
                      onTap: () {
                        setState(() {
                          selectedSupporter = supporter;
                        });
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dungeon Progress'),
      ),
      body: Column(
        children: [
          SizedBox(height: 32.0),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(
                'images/boss.jpg',
                width: 200.0,
                height: 200.0,
              ),
            ),
          ),
          LinearProgressIndicator(
            value: currentHP / maxHP,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Enemy HP: ${currentHP.toInt()}/${maxHP.toInt()}',
              style: TextStyle(fontSize: 16.0),
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
                child: Text('Attack'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  openSupportPopup(context);
                },
                child: Text('Support'),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DungeonPage(),
    );
  }
}
