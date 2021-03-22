import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ninety9names/repo/name.dart';

class Repository {
  final FirebaseFirestore _firestore;

  Repository(this._firestore);

  Stream<List<Name>> getNames() {
    return _firestore.collection("names").snapshots().map((snapshot) {
      List<Name> names = snapshot.docs
          .map((name) => Name(
              name['ID'],
              name['Arabic'],
              name['Transliteration'],
              name['MeaningShaykh'],
              name['Explanation']))
          .toList();
      names.sort((a, b) => a.id!.compareTo(b.id!));
      return names;
    });
  }
}
