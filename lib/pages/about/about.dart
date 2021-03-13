import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: [
          ListTile(
            title: Text("Description:"),
            subtitle: Text(
                "Flutter implementation of SA Bodhanya's Excel 99names application"),
          ),
          ListTile(
            title: Text("Bug Tracker & Feature Request:"),
            subtitle: GestureDetector(
              child: Text("Issue Page",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue)),
              onTap: () {
                launch(
                    'https://github.com/thameezb/ninety9names_flutter/issues/');
              },
            ),
          ),
          ListTile(
            title: Text("Developed by:"),
            subtitle: Text("tabodhanya"),
          ),
        ],
      ),
    );
  }
}
