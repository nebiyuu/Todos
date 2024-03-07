import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Todo {
  final String title;

  bool checkk;

  Todo(
    this.title,
  ) : checkk = false;
}

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox("mydb");

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Neww(
      todos: [],
    ),
  ));
}

class Neww extends StatelessWidget {
  final List<Todo> todos;

  const Neww({Key? key, required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("todo aapp"),
        backgroundColor: Colors.purple,
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
  final _mydb = Hive.box('mydb');
  Tododb ddb = Tododb();

  @override
  void initState() {
    if (_mydb.get('todolist') == null) {
      // Corrected condition
      ddb.createdata();
    } else {
      ddb.loadd();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 77, 197),
      body: ListView.builder(
        itemCount: ddb.todos.length,
        itemBuilder: ((context, index) {
          return CheckboxListTile(
            title: Text(
              ddb.todos[index].title,
              style: TextStyle(
                decoration: ddb.todos[index].checkk
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            value: ddb.todos[index].checkk,
            onChanged: (bool? newValue) {
              setState(() {
                ddb.todos[index].checkk = newValue!;
              });
              ddb.updatedd();
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
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
                      ddb.updatedd();
                      Navigator.pop(
                          context,
                          Todo(
                            title,
                          ));
                    },
                    child: const Text("save"),
                  ),
                ],
              );
            },
          );

          if (newtodo != null) {
            setState(() {
              ddb.todos.add(newtodo);
            });
            ddb.updatedd(); // Update the todos list in the box
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Tododb {
  List<Todo> todos = [];
  final _mydb = Hive.box('mydb');

  createdata() {
    todos = [
      Todo(
        " title 1",
      ),
      Todo(
        "title 2",
      )
    ];
  }

  updatedd() {
    _mydb.get('todolist', defaultValue: todos);
  }

  loadd() {
    _mydb.put('todolist', todos);
  }
}
