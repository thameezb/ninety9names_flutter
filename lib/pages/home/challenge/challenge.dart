import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/home/challenge/displayChallenge.dart';

class Challenge extends StatefulWidget {
  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DisplayChallenge(isEnglish: false),
    DisplayChallenge(isEnglish: true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.translate), label: "Arabic"),
          BottomNavigationBarItem(
              icon: Icon(Icons.text_format), label: "English"),
        ],
      ),
    );
  }
}
