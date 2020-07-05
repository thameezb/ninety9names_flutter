import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'nitety9names',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(title: 'ninety9names'),
          '/details': (context) => Details(),
        });
  }
}

class Name {
  final String id;
  final String arabic;
  final String transliteration;
  final String meaningShaykh;
  final String meaningGeneral;
  final String explanation;

  Name(this.id, this.arabic, this.transliteration, this.meaningShaykh,
      this.meaningGeneral, this.explanation);

  Name.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        arabic = json["arabic"],
        transliteration = json["transliteration"],
        meaningShaykh = json["meaning_shaykh"],
        meaningGeneral = json["meaning_general"],
        explanation = json["explanation"];
}

Widget returnFutureBuilder(future, func) {
  return Center(
    child: FutureBuilder<List<Name>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return func(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            ),
          );
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    ),
  );
}

class ViewAllNames extends StatefulWidget {
  ViewAllNames({Key key, this.futureNames}) : super(key: key);
  final Future<List<Name>> futureNames;
  @override
  _ViewAllNamesState createState() => _ViewAllNamesState();
}

class _ViewAllNamesState extends State<ViewAllNames> {
  ListView displayNames(List<Name> names) {
    return ListView(
        children: names
            .map((n) => Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/details', arguments: n);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: ListTile(
                      title: Text('${n.id}. ${n.transliteration}'),
                      trailing: Text(n.arabic),
                    ),
                  ),
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return returnFutureBuilder(widget.futureNames, displayNames);
  }
}

List<Widget> displayName(Name n) {
  Widget formatFields(String t, String st) {
    return Expanded(child: ListTile(title: Text(t), subtitle: Text(st)));
  }

  return ([
    formatFields('Number:', n.id),
    formatFields('Arabic:', n.arabic),
    formatFields('Transliteration:', n.transliteration),
    formatFields('Meaning:', n.meaningGeneral),
    formatFields("Shaykh's meaning:", n.meaningShaykh),
    formatFields('Explanation:', n.explanation),
  ]);
}

class Details extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final Name n = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(n.arabic),
      ),
      body: Center(
        child: ListView(
          children: displayName(n),
        ),
      ),
    );
  }
}

class Challenge extends StatefulWidget {
  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  Future<Name> futureName;
  TextEditingController _controller;
  bool isEnglish;
  int _currentIndex = 0;
  int score = 0;

  Future<Name> fetchName(String url) async {
    final response = await http.get(url);
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
    _controller.dispose();
    super.dispose();
  }

  displayAnswer(Name n, bool isCorrect, isEnglish) async {
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
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.green,
              child: Text("Try another"),
            )
          ],
        );
      },
    );
  }

  checkAnswer(Name n, String answer, bool isEnglish) async {
    if (answer == "") {
      return null;
    }

    bool isCorrect;
    if (isEnglish == true) {
      if (n.transliteration.toLowerCase().compareTo(answer.toLowerCase()) ==
          0) {
        isCorrect = true;
      }
    } else {
      if (n.meaningShaykh.toLowerCase().compareTo(answer.toLowerCase()) == 0) {
        isCorrect = true;
      }
    }
    await displayAnswer(n, isCorrect, isEnglish);
  }

  Text getTitle(Name n, bool isEnglish) {
    String title = "${n.arabic} - ${n.transliteration}";
    if (isEnglish == true) {
      title = n.meaningShaykh;
    }
    return Text(title, style: TextStyle(fontSize: 25));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Name>(
        future: futureName,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Name n = snapshot.data;
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
                                  _controller.clear();
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
                        RaisedButton(
                          onPressed: () {
                            checkAnswer(n, _controller.text, isEnglish);
                            _controller.clear();
                            setState(() {
                              futureName = fetchName(
                                  "https://ninety9names.herokuapp.com/bff/names/r");
                            });
                          },
                          color: Colors.green,
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
                      icon: Icon(Icons.translate), title: Text("Arabic")),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.trending_up), title: Text("High Scores")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.text_format), title: Text("English")),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ],
              ),
            );
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: [
          ListTile(
            title: Text("Description:"),
            subtitle: Text(
                "Flutter implementation of SA Bodhanya's Excel 99names application"),
          ),
          ListTile(
            title: Text("Bug Tracker & Feature Request:"),
            subtitle: GestureDetector(
              child: Text("Issue Page",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue)),
              onTap: () {
                launch(
                    'https://github.com/thameezb/ninety9names_flutter/issues/');
              },
            ),
          ),
          ListTile(
            title: Text("Developed by:"),
            subtitle: Text("tabodhanya"),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Name>> futureNames;

  Future<List<Name>> fetchNames(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var names = json.decode(response.body) as List;
      return names.map((n) => Name.fromJson(n)).toList();
    } else {
      throw Exception('Failed to load names');
    }
  }

  @override
  void initState() {
    super.initState();
    futureNames = fetchNames("https://ninety9names.herokuapp.com/bff/names");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            bottom: TabBar(tabs: [
              Tab(text: 'Names'),
              Tab(text: 'Challenge'),
              Tab(text: 'About'),
            ])),
        body: TabBarView(
          children: [
            ViewAllNames(futureNames: futureNames),
            Challenge(),
            About(),
          ],
        ),
      ),
    );
  }
}
