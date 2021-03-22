import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/routes/routes.dart';

class Ninety9Names extends StatefulWidget {
  _Ninety9NamesState createState() => _Ninety9NamesState();
}

class _Ninety9NamesState extends State<Ninety9Names> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return ErrorWidget("failed to connect with Firebase");
    }
    if (!_initialized) {
      return CircularProgressIndicator();
    }
    return MaterialApp(
      title: 'ninety9names',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: getRoutes(),
    );
  }
}
