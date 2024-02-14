// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Neww()));

class Neww extends StatefulWidget {
  const Neww({super.key});

  @override
  State<Neww> createState() => _NewwState();
}

class _NewwState extends State<Neww> {
  String inputed = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(inputed)),
      body: Center(
        child: TextField(
          decoration: InputDecoration(hintText: "  write here "),
          onChanged: (value) {
            setState(() {
              inputed = value;
            });
          },
        ),
      ),
      bottomSheet: Container(
        alignment: Alignment.center,
        height: 50,
        child: Text("you wrote  $inputed  "),
      ),
    );
  }
}
