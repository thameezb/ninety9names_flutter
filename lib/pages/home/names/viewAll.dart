import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninety9names/repo/firestore.dart';
import 'package:ninety9names/repo/name.dart';
import 'package:provider/provider.dart';

class ViewAllNames extends StatefulWidget {
  ViewAllNames({Key? key}) : super(key: key);

  @override
  _ViewAllNamesState createState() => _ViewAllNamesState();
}

class _ViewAllNamesState extends State<ViewAllNames> {
  late Stream<List<Name>> _namesStream;

  @override
  void initState() {
    super.initState();
    _namesStream = context.read<Repository>().getNames();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: _namesStream, builder: _displayNames);
  }

  Widget _displayNames(
      BuildContext context, AsyncSnapshot<List<Name>> snapshot) {
    if (snapshot.hasError) {
      return Center(
          child: ErrorWidget(
              "Failed to read snapshot data -" + snapshot.error.toString()));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
        children: snapshot.data!
            .map((n) => Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/details', arguments: n);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: ListTile(
                      title: Text(n.transliteration!),
                      trailing: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          n.arabic!.trim() + '  ',
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList());
  }
}
