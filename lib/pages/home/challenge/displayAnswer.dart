import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/names/details.dart';
import 'package:ninety9names/repo/name.dart';

displayAnswer(Name n, bool isCorrect, bool isEnglish) async {
  Column title = Column(
    children: [
      Icon(Icons.thumb_down, color: Colors.red),
      Text(
        "Sorry, your answer is incorrect",
        style: TextStyle(fontSize: 20, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    ],
  );

  if (isCorrect == true) {
    title = Column(
      children: [
        Icon(Icons.thumb_up, color: Colors.green),
        Text(
          "Correct!",
          style: TextStyle(fontSize: 20, color: Colors.green),
          textAlign: TextAlign.center,
        ),
      ],
    );
    // setState(() {
    //   score++;
    // });
  }

  List<Widget> getDialog(Name n) {
    List<Widget> dialog = [
      ListTile(title: title),
      ListTile(
          title: Text(
        "${n.arabic} translates to ${n.meaning}",
        textAlign: TextAlign.center,
      )),
    ];
    dialog.addAll(displayName(n));
    return dialog;
  }

  // await showDialog(
  //   context: context,
  //   builder: (context) {
  //     return AlertDialog(
  //       content: Container(
  //         height: MediaQuery.of(context).size.height * 0.9,
  //         child: Column(children: getDialog(n)),
  //       ),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: Text("Try another"),
  //         )
  //       ],
  //     );
  //   },
  // );
}
