// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Neww()));

class Neww extends StatefulWidget {
  const Neww({super.key});

  @override
  State<Neww> createState() => _NewwState();
}

class _NewwState extends State<Neww> {
  bool mycolor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("inputed")),
        body: GestureDetector(
            child: Container(
              height: 300,
              width: 300,
              color: getcolor(),
            ),
            onTap: () {
              if (mycolor) {
                setState(() {
                  mycolor = false;
                });
              } else {
                setState(() {
                  mycolor = true;
                });
              }
            }));
  }

  Color getcolor() {
    if (mycolor) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
