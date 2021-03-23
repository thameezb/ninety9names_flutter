import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/challenge/utils.dart';
import 'package:ninety9names/pages/home/names/details.dart';
import 'package:ninety9names/repo/name.dart';

class AnswerTextBox extends StatelessWidget {
  AnswerTextBox(
    this.currentName,
    this.isEnglish,
    this.setCurrentNameState,
    this.clearController,
    this.controller,
  );

  final Name currentName;
  final bool isEnglish;
  final VoidCallback setCurrentNameState;
  final VoidCallback clearController;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: TextField(
              controller: controller,
              onSubmitted: (String answer) {
                handleSubmit(currentName, answer, isEnglish,
                    setCurrentNameState, clearController);
              },
              decoration: InputDecoration(
                  labelText: 'Enter your answer',
                  border: UnderlineInputBorder()),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ]),
        Column(children: [
          ElevatedButton(
              onPressed: () {
                handleSubmit(currentName, controller.text, isEnglish,
                    setCurrentNameState, clearController);
              },
              child: Text("Submit"))
        ]),
      ],
    );
  }

  Future<void> handleSubmit(
    Name currentName,
    String answer,
    bool isEnglish,
    VoidCallback setCurrentNameState,
    VoidCallback clearController,
  ) async {
    await displayAnswer(
        currentName, checkAnswer(currentName, answer, isEnglish), isEnglish);
    setCurrentNameState();
    clearController();
  }

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
}
