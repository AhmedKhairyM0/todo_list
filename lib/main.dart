import 'package:flutter/material.dart';
import 'package:todo_app/layout/home.dart';

main() {  
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
