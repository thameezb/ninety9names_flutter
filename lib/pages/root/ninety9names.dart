import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/home.dart';
import 'package:ninety9names/pages/names/details.dart';

class Ninety9Names extends StatelessWidget {
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
          '/': (context) => Home(title: 'ninety9names'),
          '/details': (context) => Details(),
        });
  }
}
