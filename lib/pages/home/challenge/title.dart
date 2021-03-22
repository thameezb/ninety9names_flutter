import 'package:flutter/material.dart';
import 'package:ninety9names/repo/name.dart';

class ChallengeTitle extends StatelessWidget {
  ChallengeTitle({required this.isEnglish, required this.currentName});
  final bool isEnglish;
  final Name currentName;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(title: Text("Do you know the meaning of?")),
      Center(
        child: getTitle(currentName, isEnglish),
      ),
    ]);
  }

  Text getTitle(Name n, bool isEnglish) {
    String? title = "${n.arabic} - ${n.transliteration}";
    if (isEnglish == true) {
      title = n.meaning;
    }
    return Text(title!, style: TextStyle(fontSize: 25));
  }
}
