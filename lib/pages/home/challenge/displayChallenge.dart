import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/challenge/answerTextBox.dart';
import 'package:ninety9names/pages/home/challenge/utils.dart';
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

          VoidCallback setCurrentNameState = () {
            setState(() {
              currentName = getRandomName(names);
            });
          };

          VoidCallback clearController = () {
            _controller.clear();
          };

          return Column(
            children: [
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(title: Text("Do you know the meaning of?")),
                      Center(
                          child: getTitleText(currentName, widget.isEnglish)),
                      AnswerTextBox(currentName, widget.isEnglish,
                          setCurrentNameState, clearController, _controller),
                    ]),
              ),
            ],
          );
        });
  }
}
