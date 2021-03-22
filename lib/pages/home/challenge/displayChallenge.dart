import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/names/details.dart';
import 'package:ninety9names/repo/firestore.dart';
import 'package:ninety9names/repo/name.dart';
import 'package:provider/provider.dart';

class DisplayChallenge extends StatefulWidget {
  final bool isEnglish;
  DisplayChallenge({required this.isEnglish});

  @override
  _DisplayChallengeState createState() => _DisplayChallengeState();
}

class _DisplayChallengeState extends State<DisplayChallenge> {
  _DisplayChallengeState();

  late Stream<List<Name>> _namesStream;
  late TextEditingController _controller;
  int score = 0;

  @override
  initState() {
    super.initState();
    _controller = TextEditingController();
    _namesStream = context.read<Repository>().getNames();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _namesStream,
        builder: (BuildContext context, AsyncSnapshot<List<Name>> snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(
                "Failed to read snapshot data -" + snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Name> names = snapshot.data!;
          Name currentName = getRandomName(names);

          return Column(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(title: Text("Do you know the meaning of?")),
                    Center(
                      child: getTitle(currentName, widget.isEnglish),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: TextField(
                            controller: _controller,
                            onSubmitted: (String value) {
                              handleSubmit(
                                  currentName, value, widget.isEnglish);
                              setState(() {
                                currentName = getRandomName(names);
                              });
                            },
                            decoration: InputDecoration(
                                labelText: 'Enter your answer',
                                border: UnderlineInputBorder()),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        handleSubmit(
                            currentName, _controller.text, widget.isEnglish);
                        setState(() {
                          currentName = getRandomName(names);
                        });
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Name getRandomName(List<Name> names) {
    Random random = new Random();
    return names[random.nextInt(names.length)];
  }

  handleSubmit(Name currentName, String value, bool isEnglish) {
    checkAnswer(currentName, value, isEnglish);
    _controller.clear();
  }

  displayAnswer(Name n, bool? isCorrect, isEnglish) async {
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
      setState(() {
        score++;
      });
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

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(children: getDialog(n)),
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

  checkAnswer(Name n, String answer, bool? isEnglish) async {
    if (answer == "") {
      return null;
    }

    bool? isCorrect;
    if (isEnglish == true) {
      if (n.transliteration!.toLowerCase().compareTo(answer.toLowerCase()) ==
          0) {
        isCorrect = true;
      }
    } else {
      if (n.meaning!.toLowerCase().compareTo(answer.toLowerCase()) == 0) {
        isCorrect = true;
      }
    }
    await displayAnswer(n, isCorrect, isEnglish);
  }

  Text getTitle(Name n, bool? isEnglish) {
    String? title = "${n.arabic} - ${n.transliteration}";
    if (isEnglish == true) {
      title = n.meaning;
    }
    return Text(title!, style: TextStyle(fontSize: 25));
  }
}
