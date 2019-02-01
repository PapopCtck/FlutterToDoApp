import 'package:flutter/material.dart';
import 'package:todoapp/ui/todo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("ToDoApp"),
        backgroundColor: Colors.black54,
      ),
      body: new ToDoScreen(),
    );
  }
}