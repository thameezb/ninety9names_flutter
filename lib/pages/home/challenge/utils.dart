import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ninety9names/repo/name.dart';

Name getRandomName(List<Name> names) {
  Random random = new Random();
  return names[random.nextInt(names.length)];
}

Text getTitleText(Name n, bool isEnglish) {
  String? title = "${n.arabic} - ${n.transliteration}";
  if (isEnglish == true) {
    title = n.meaning;
  }
  return Text(title!, style: TextStyle(fontSize: 25));
}

bool checkAnswer(Name name, String answer, bool isEnglish) {
  bool isCorrect = false;
  if (answer == "") {
    return isCorrect;
  }

  if (isEnglish == true) {
    return (name.transliteration!
                .toLowerCase()
                .compareTo(answer.toLowerCase()) ==
            0 ||
        name.arabic!.toLowerCase().compareTo(answer.toLowerCase()) == 0);
  } else {
    return (name.meaning!.toLowerCase().compareTo(answer.toLowerCase()) == 0);
  }
}
