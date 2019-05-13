import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/contact.dart';

class FirestoreDB {
  static final FirestoreDB _singleton = FirestoreDB._internal();

  final CollectionReference contacts =
      Firestore.instance.collection('contacts');

  factory FirestoreDB() {
    return _singleton;
  }

  FirestoreDB._internal() {}

  String generateContactID() {
    DocumentReference ref = contacts.document();
    return ref.documentID;
  }

  Future<DocumentReference> pushContactToContactsList(Contact contact) async {
    DocumentReference handle;

    try {
      handle = await contacts.add(contact.toMap());
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
