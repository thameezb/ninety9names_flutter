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
  return Text(
    title!,
    style: TextStyle(fontSize: 20),
    textAlign: TextAlign.center,
  );
}

bool checkAnswer(Name name, String answer, bool isEnglish) {
  bool isCorrect = false;
  if (answer == "") {
    return isCorrect;
  }

  if (isEnglish == true) {
    return (_sanitize(name.transliteration!).compareTo(_sanitize(answer)) ==
            0 ||
        _sanitize(name.arabic!).compareTo(_sanitize(answer)) == 0);
  } else {
    List<String> compound = name.meaning!.split(";");
    if (compound.length == 0) {
      return (_sanitize(name.meaning!).compareTo(_sanitize(answer)) == 0);
    }
    for (String c in compound) {
      if (_sanitize(c).compareTo(_sanitize(answer)) == 0) {
        isCorrect = true;
      }
    }
    return isCorrect;
  }
}

String _sanitize(String input) {
  return input.replaceAll('-', ' ').toLowerCase().trim();
}
