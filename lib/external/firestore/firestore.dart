import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/contact.dart';

class FirestoreDB {
  static final FirestoreDB _singleton = FirestoreDB._internal();

  FirestoreDB._internal();

  final CollectionReference users = Firestore.instance.collection('users');

  factory FirestoreDB() {
    return _singleton;
  }

  String generateContactID() {
    DocumentReference ref = users.document();
    return ref.documentID;
  }

  Future<bool> deleteContactFromDB(String dbId) async {
    DocumentReference handle;

    print("Deleting dbID " + dbId);

    try {
      handle = users.document(dbId);

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

  Future<DocumentReference> pushContactToContactsList(
      Contact contact, String googleId) async {
    DocumentReference handle;

    try {
      print(contact.id);
      handle = users.document(googleId);

      DocumentReference contactDocRef =
          handle.collection("contacts").document(contact.id);

      print(contactDocRef.path);

      await contactDocRef.setData(contact.toMap());
    } catch (e) {
      print(e);
    }

    return handle;
  }

  Future<List<Map<String, dynamic>>> getContactsFromDB(String googleId) async {
    DocumentReference userData = users.document(googleId);

    CollectionReference contactRef = userData.collection("contacts");
    QuerySnapshot contacts = await contactRef.getDocuments();

    List<DocumentSnapshot> dataList = contacts.documents;

    return dataList.map((DocumentSnapshot docSnap) {
      return docSnap.data;
    }).toList();
  }
}
