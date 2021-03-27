import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/repo/name.dart';

class Details extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final Name n = ModalRoute.of(context)!.settings.arguments as Name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          n.arabic!.trim() + '  ',
          textDirection: TextDirection.rtl,
        ),
      ),
      body: Center(
        child: ListView(
          children: displayName(n),
        ),
      ),
    );
  }
}

List<Widget> displayName(Name n) {
  Widget formatFields(String t, String st) {
    return ListTile(title: Text(t), subtitle: Text(st));
  }

  return ([
    formatFields('Arabic:', n.arabic!),
    formatFields('Transliteration:', n.transliteration!),
    formatFields('Meaning:', n.meaning!),
    formatFields('Explanation:', n.explanation!),
  ]);
}
