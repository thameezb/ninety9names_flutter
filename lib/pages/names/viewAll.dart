import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../repo/name.dart';

Widget returnFutureBuilder(future, func) {
  return Center(
    child: FutureBuilder<List<Name>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return func(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            ),
          );
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    ),
  );
}

class ViewAllNames extends StatefulWidget {
  ViewAllNames({Key? key, this.futureNames}) : super(key: key);
  final Future<List<Name>>? futureNames;
  @override
  _ViewAllNamesState createState() => _ViewAllNamesState();
}

class _ViewAllNamesState extends State<ViewAllNames> {
  ListView displayNames(List<Name> names) {
    return ListView(
        children: names
            .map((n) => Card(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: n);
            },
            behavior: HitTestBehavior.translucent,
            child: ListTile(
              title: Text('${n.id}. ${n.transliteration}'),
              trailing: Text(n.arabic!),
            ),
          ),
        ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return returnFutureBuilder(widget.futureNames, displayNames);
  }
}
