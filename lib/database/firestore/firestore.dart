import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/contact.dart';

class FirestoreDB {
  static final FirestoreDB _singleton = FirestoreDB._internal();

  FirestoreDB._internal() {}

  final CollectionReference contacts =
      Firestore.instance.collection('contacts');

  factory FirestoreDB() {
    return _singleton;
  }

  String generateContactID() {
    DocumentReference ref = contacts.document();
    return ref.documentID;
  }

  Future<bool> deleteContactFromDB(String dbId) async {
    DocumentReference handle;

    print("Deleting dbID " + dbId);

    try {
      handle = contacts.document(dbId);

      if (handle == null) {
        return false;
      } else {
        print("Handle is valid.");
      }

      DocumentSnapshot ds = await handle.get();
      await ds.reference.delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DocumentReference> pushContactToContactsList(Contact contact) async {
    DocumentReference handle;

    try {
      handle = contacts.document(contact.id);
      await handle.setData(contact.toMap());
    } catch (e) {
      print(e);
    }

    return handle;
  }

  Future<List<Map<String, dynamic>>> getContactsFromDB() async {
    QuerySnapshot snap = await contacts.getDocuments();

    List<DocumentSnapshot> documents = snap.documents;

    return documents.map((DocumentSnapshot docSnap) {
      return docSnap.data;
    }).toList();
  }
}
