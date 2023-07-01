import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログインページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '氏名',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: '氏名を入力してください',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'パスワード',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              maxLength: 8,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: '8桁のパスワードを入力してください',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  print('ログインボタンが押されました');

                  String name = nameController.text;
                  String password = passwordController.text;
                  print("name: ${name}");

                  Map<String, String> data = {
                    'name': name,
                    'password': password,
                  };

                  var response = await http.get(
                    Uri.parse(
                        'https://bene-hack-api.azurewebsites.net/api/User'), // ここに適切なAPIのURLを設定してください
                    headers: {"Content-Type": "application/json"},
                  );
                  print('レスポンス：${response.body}');

                  if (response.statusCode == 200) {
                    _showPopup(context);
                  } else {
                    // Handle error here
                    //ログを出力する
                    print('error');
                  }
                },
                child: const Text(
                  'ログイン',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ログインボーナス!',
            textAlign: TextAlign.center,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '今日のアイテム',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image.asset(
                'images/boss.jpg',
                height: 100,
                width: 100,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage()),
                );
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('次のページ'),
      ),
      body: Center(
        child: const Text('次のページです'),
      ),
    );
  }
}
