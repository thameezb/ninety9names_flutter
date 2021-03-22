import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/names/details.dart';
import 'package:ninety9names/pages/names/model.dart';
import 'package:http/http.dart' as http;

class Challenge extends StatefulWidget {
  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  Future<Name>? futureName;
  TextEditingController? _controller;
  bool? isEnglish;
  int _currentIndex = 0;
  int score = 0;

  Future<Name> fetchName(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Name.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load names');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    futureName = fetchName("https://ninety9names.herokuapp.com/bff/names/r");
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
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
          "${n.arabic} translates to ${n.meaningShaykh}",
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
      if (n.meaningShaykh!.toLowerCase().compareTo(answer.toLowerCase()) == 0) {
        isCorrect = true;
      }
    }
    await displayAnswer(n, isCorrect, isEnglish);
  }

  Text getTitle(Name n, bool? isEnglish) {
    String? title = "${n.arabic} - ${n.transliteration}";
    if (isEnglish == true) {
      title = n.meaningShaykh;
    }
    return Text(title!, style: TextStyle(fontSize: 25));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Name>(
        future: futureName,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Name n = snapshot.data!;
            return Scaffold(
              body: Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(title: Text("Do you know the meaning of?")),
                        Center(
                          child: getTitle(n, isEnglish),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: TextField(
                                controller: _controller,
                                onSubmitted: (String value) {
                                  checkAnswer(n, value, isEnglish);
                                  _controller!.clear();
                                  setState(() {
                                    futureName = fetchName(
                                        "https://ninety9names.herokuapp.com/bff/names/r");
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
                            checkAnswer(n, _controller!.text, isEnglish);
                            _controller!.clear();
                            setState(() {
                              futureName = fetchName(
                                  "https://ninety9names.herokuapp.com/bff/names/r");
                            });
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (int index) {
                  setState(() {
                    futureName = fetchName(
                        "https://ninety9names.herokuapp.com/bff/names/r");
                  });
                  _currentIndex = index;
                  isEnglish = index == 1;
                },
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.translate), label: "Arabic"),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.trending_up), title: Text("High Scores")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.text_format), label: "English"),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
