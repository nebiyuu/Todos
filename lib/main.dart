import 'package:flutter/material.dart';

class Todo {
  final String title;

  bool checkk = false;

  Todo(
    this.title,
  );
}

List<Todo> todos = [
  Todo(
    " title 1",
  ),
  Todo(
    "title 2",
  )
];

void main() => runApp(MaterialApp(
      home: Neww(
        todos: todos,
      ),
    ));

class Neww extends StatelessWidget {
  final List<Todo> todos;

  const Neww({Key? key, required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("todo app"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: const Foo(),
    );
  }
}

class Foo extends StatefulWidget {
  const Foo({Key? key}) : super(key: key);

  @override
  State<Foo> createState() => _FooState();
}

class _FooState extends State<Foo> {
  late String title;
  late bool checkk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: ((context, index) {
          return CheckboxListTile(
            title: Text(
              todos[index].title,
              // Apply line-through decoration if the title starts with 'done'
              style: TextStyle(
                decoration: todos[index].title.startsWith("done")
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            value: todos[index].checkk,
            onChanged: (bool? newValue) {
              setState(() {
                todos[index].checkk = newValue!;
              });
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Todo? newtodo = await showDialog<Todo>(
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
                      if (title != null) {
                        Navigator.pop(
                            context,
                            Todo(
                              title,
                            ));
                      }
                    },
                    child: const Text("save"),
                  ),
                ],
              );
            },
          );

          if (newtodo != null) {
            setState(() {
              todos.add(newtodo);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
