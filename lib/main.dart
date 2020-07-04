import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(title: 'ninety9names'),
          '/details': (context) => Details(),
        });
  }
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
          children: [
            ListTile(title: Text('Number: ${n.id}')),
            ListTile(title: Text('Transliteration: ${n.transliteration}')),
            ListTile(title: Text('Meaning: ${n.meaningGeneral}')),
            ListTile(title: Text("Shaykh's meaning: ${n.meaningShaykh}")),
            ListTile(title: Text('Explanation: ${n.explanation}'))
          ],
        ),
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

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Name>> futureNames;

  @override
  void initState() {
    super.initState();
    futureNames = fetchName("https://ninety9names.herokuapp.com/bff/names");
  }

  Future<List<Name>> fetchName(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var names = json.decode(response.body) as List;
      return names.map((n) => Name.fromJson(n)).toList();
    } else {
      throw Exception('Failed to load names');
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Name>>(
          future: futureNames,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return displayNames(snapshot.data);
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
      ),
    );
  }
}
