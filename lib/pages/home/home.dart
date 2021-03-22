import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/about/about.dart';
import 'package:ninety9names/pages/challenge/challenge.dart';
import 'package:ninety9names/pages/names/model.dart';
import 'package:http/http.dart' as http;
import 'package:ninety9names/pages/names/viewAll.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
