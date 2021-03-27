import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/names/details.dart';
import 'package:ninety9names/repo/name.dart';

displayAnswer(Name n, bool isCorrect, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(children: _getDialog(n, isCorrect)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Try another"),
          )
        ],
      );
    },
  );
}

List<Widget> _getDialog(Name n, bool isCorrect) {
  List<Widget> dialog = [
    ListTile(title: _getTitleWidget(isCorrect)),
    ListTile(
        title: Text(
      "${n.arabic} translates to ${n.meaning}",
      textAlign: TextAlign.center,
    )),
  ];
  dialog.addAll(displayName(n));
  return dialog;
}

Column _getTitleWidget(bool isCorrect) {
  Color colour = Colors.red;
  IconData icon = Icons.thumb_down;
  String text = "Sorry, your answer is incorrect";

  if (isCorrect) {
    colour = Colors.green;
    icon = Icons.thumb_up;
    text = "Correct!";
  }

  return Column(
    children: [
      Icon(icon, color: colour),
      Text(
        text,
        style: TextStyle(fontSize: 20, color: colour),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
