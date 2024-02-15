// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Neww()));

class Neww extends StatefulWidget {
  const Neww({super.key});

  @override
  State<Neww> createState() => _NewwState();
}

class _NewwState extends State<Neww> {
  List<String> todolist = ["todo 1", "todo 2"];

  void todomethode() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String todo = "";
          return AlertDialog(
            title: Text("input your list"),
            content: TextField(
              onChanged: (value) {
                todo = value;
              },
              decoration: InputDecoration(hintText: "write here"),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: Navigator.of(context).pop, child: Text("cancel")),
              TextButton(
                onPressed: () {
                  setState(
                    () {
                      todolist.add(todo);
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: Text("save"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("todo list app")),
      body: ListView.builder(
          itemCount: todolist.length,
          itemBuilder: (context, index) {
            final varr = todolist[index];
            return ListTile(
              onTap: () {
                setState(() {
                  if (varr.startsWith("done")) {
                    todolist[index] = varr.substring(2);
                  } else {
                    todolist[index] = 'done $varr';
                  }
                });
              },
              title: Text(
                varr,
                style: TextStyle(
                    decoration: varr.startsWith("done")
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todomethode();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
