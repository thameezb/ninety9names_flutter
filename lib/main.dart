import 'package:flutter/material.dart';

import 'package:ninety9names/pages/home/home.dart';
import 'package:ninety9names/pages/names/details.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ninety9names',
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






