import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dunjion_app/ui/Dungeon.dart';

class NextTestPage extends StatelessWidget {
  const NextTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Text('Next Test Page'),
    );
  }
}
