import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String disc;

  const Todo(this.title, this.disc);
}

List<Todo> todos = [
  const Todo(" title 1", "disc 1"),
  const Todo("title 2", "disc 2")
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
      body: Foo(),
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
  late String disc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text(
              todos[index].title,
              // Apply line-through decoration if the title starts with 'done'
              style: TextStyle(
                decoration: todos[index].title.startsWith("done")
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Decpage(todo: todos[index]),
                ),
              );
            },
            onLongPress: () {
              setState(
                () {
                  // Toggle the 'done' prefix for the title
                  if (todos[index].title.startsWith("done")) {
                    todos[index] = Todo(
                        todos[index].title.substring(5), todos[index].disc);
                  } else {
                    todos[index] =
                        Todo('done ${todos[index].title}', todos[index].disc);
                  }
                },
              );
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
                    TextField(
                      decoration: const InputDecoration(labelText: "disc"),
                      onChanged: (value) => setState(() => disc = value),
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
                      if (title != null && disc != null) {
                        Navigator.pop(context, Todo(title, disc));
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

class Decpage extends StatelessWidget {
  final Todo todo;

  const Decpage({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
      body: Center(child: Text(todo.disc)),
    );
  }
}
