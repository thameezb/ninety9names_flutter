import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/about/about.dart';
import 'package:ninety9names/pages/home/challenge/challenge.dart';
import 'package:ninety9names/pages/home/names/viewAll.dart';

class Home extends StatefulWidget {
  Home({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          bottom: TabBar(tabs: [
            Tab(text: 'Names'),
            // Tab(text: 'Challenge'),
            Tab(text: 'About'),
          ]),
        ),
        body: TabBarView(
          children: [
            ViewAllNames(),
            // Challenge(),
            About(),
          ],
        ),
      ),
    );
  }
}
