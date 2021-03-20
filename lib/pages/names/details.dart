import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/pages/names/model.dart';

List<Widget> displayName(Name n) {
  Widget formatFields(String t, String st) {
    return Expanded(child: ListTile(title: Text(t), subtitle: Text(st)));
  }

  return ([
    formatFields('Number:', n.id),
    formatFields('Arabic:', n.arabic),
    formatFields('Transliteration:', n.transliteration),
    formatFields('Meaning:', n.meaningGeneral),
    formatFields("Shaykh's meaning:", n.meaningShaykh),
    formatFields('Explanation:', n.explanation),
  ]);
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
          children: displayName(n),
        ),
      ),
    );
  }
}
