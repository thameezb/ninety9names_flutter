import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/challenge/displayAnswer.dart';
import 'package:ninety9names/pages/home/challenge/utils.dart';
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
              decoration: InputDecoration(
                  labelText: 'Enter your answer',
                  border: UnderlineInputBorder()),
              onSubmitted: (String answer) {
                _handleSubmit(currentName, answer, isEnglish,
                    setCurrentNameState, clearController, context);
              },
            ),
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ]),
        Column(children: [
          ElevatedButton(
              onPressed: () {
                _handleSubmit(currentName, controller.text, isEnglish,
                    setCurrentNameState, clearController, context);
              },
              child: Text("Submit"))
        ]),
      ],
    );
  }

  void _handleSubmit(
      Name currentName,
      String answer,
      bool isEnglish,
      VoidCallback setCurrentNameState,
      VoidCallback clearController,
      BuildContext context) {
    displayAnswer(
        currentName, checkAnswer(currentName, answer, isEnglish), context);
    setCurrentNameState();
    clearController();
  }
}
