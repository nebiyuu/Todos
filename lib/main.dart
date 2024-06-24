import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Todo {
  final String title;
  bool checkk;

  Todo(
    this.title, {
    this.checkk = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'checkk': checkk,
    };
  }
}

List<Todo> todos = [
  Todo(
    "title 1",
  ),
  Todo(
    "title 2",
  )
];

void main() => runApp(MaterialApp(
      // Dark theme configuration

      darkTheme: ThemeData.dark().copyWith(
        // Dark Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
      ),
      themeMode: ThemeMode.system,
      home: Neww(
        todos: todos,
        storage: Tododb(),
      ),
    ));

class Tododb {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todo.txt');
  }

  Future<void> writeTodos(List<Todo> todos) async {
    final file = await _localFile;
    List<Map<String, dynamic>> todoListJson =
        todos.map((todo) => todo.toJson()).toList();
    String todosJson = json.encode(todoListJson);
    await file.writeAsString(todosJson);
  }

  Future<List<Todo>> readTodos() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        // If the file doesn't exist, return an empty list
        return [];
      }
      String contents = await file.readAsString();
      List<dynamic> todoListJson = json.decode(contents);
      List<Todo> todos = todoListJson
          .map((todoJson) => Todo(
                todoJson['title'],
                checkk: todoJson['checkk'],
              ))
          .toList();
      return todos;
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteTodo(String title) async {
    List<Todo> todos = await readTodos();
    todos.removeWhere((todo) => todo.title == title);
    await writeTodos(todos);
  }
}

class Neww extends StatefulWidget {
  final List<Todo> todos;
  final Tododb storage;

  const Neww({Key? key, required this.todos, required this.storage})
      : super(key: key);

  @override
  _NewwState createState() => _NewwState();
}

class _NewwState extends State<Neww> {
  late String title;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    List<Todo> loadedTodos = await widget.storage.readTodos();
    setState(() {
      widget.todos.clear();
      widget.todos.addAll(loadedTodos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("todo app"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.todos.length,
        itemBuilder: ((context, index) {
          final todoo = widget.todos[index];

          return Dismissible(
            key: Key(todoo.title),
            background: Container(
              color: Colors.deepPurpleAccent,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) async {
              await widget.storage.deleteTodo(todoo.title);
              setState(() {
                todos.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todoo.title} dismissed')),
              );
            },
            child: CheckboxListTile(
              title: Text(
                widget.todos[index].title,
                style: TextStyle(
                  decoration: widget.todos[index].checkk
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              value: widget.todos[index].checkk,
              onChanged: (bool? newValue) {
                setState(() {
                  widget.todos[index].checkk = newValue!;
                  widget.storage.writeTodos(widget.todos);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Todo? newTodo = await showDialog<Todo>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("add todo"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(labelText: "title"),
                      onChanged: (value) => setState(() => title = value),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      if (title.isNotEmpty) {
                        Navigator.pop(
                          context,
                          Todo(
                            title,
                          ),
                        );
                      }
                    },
                    child: const Text("save"),
                  ),
                ],
              );
            },
          );

          if (newTodo != null) {
            setState(() {
              widget.todos.add(newTodo);
              widget.storage.writeTodos(widget.todos);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
