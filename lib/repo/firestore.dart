import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ninety9names/repo/name.dart';

class Repository {
  final FirebaseFirestore _firestore;

  Repository(this._firestore);

  Stream<List<Name>> getNames() {
    return _firestore.collection("names").snapshots().map((snapshot) {
      return snapshot.docs
          .map((name) => Name(name['id'], name['arabic'],
              name['transliteration'], name['meaning'], name['explanation']))
          .toList();
    });
  }
}
