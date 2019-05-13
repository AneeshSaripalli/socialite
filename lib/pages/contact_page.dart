import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:socialite/database/firestore/firestore.dart';
import 'package:socialite/widgets/contact_list.dart';

import '../models/contact.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contactList = [];
  bool needToRefresh = true;

  List<Contact> genRandomContacts(int length) {
    List<Contact> cList = List<Contact>();

    for (int i = 0; i < length; ++i) {
      cList.add(Contact(
          description: randomString(200),
          lastName: randomString(10),
          firstName: randomString(10),
          id: randomString(10),
          phoneNumber: randomString(10)));
    }

    return cList;
  }

  PreferredSize _buildAppBar(BuildContext ctx) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        title: Text(
          "Contact List",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0),
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _handleAddContactPress(BuildContext ctx) {
    Navigator.pushNamed(ctx, '/add_contact');
  }

  FloatingActionButton _buildAddContactBtn(BuildContext ctx) {
    return FloatingActionButton(
      onPressed: () => _handleAddContactPress(ctx),
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.add,
        color: Colors.white70,
      ),
    );
  }

  Future<Null> _syncContactList() {
    if (needToRefresh) {
      setState(() {
        _updateContactList();
        needToRefresh = false;
      });
    }
    return null;
  }

  @override
  void initState() {
    _syncContactList();
  }

  Widget _buildBody(BuildContext ctx) {
    Widget optionalContactList;

    if (contactList.length == 0) {
      optionalContactList =
          Center(child: Container(child: CircularProgressIndicator()));
    } else {
      optionalContactList =
          ContactList(contacts: contactList.length == 0 ? [] : contactList);
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(colors: [Colors.black, Colors.teal]),
        ),
        child: optionalContactList);
  }

  Future<void> _updateContactList() async {
    print("Update contact list called");

    List<Map<String, dynamic>> dbData = await FirestoreDB().getContactsFromDB();
    List<Contact> contactList = dbData.map((record) {
      return Contact.fromMap(record);
    }).toList();

    setState(() {
      this.contactList = contactList;
    });
  }

  @override
  void didUpdateWidget(ContactPage oldPage) {
    super.didUpdateWidget(oldPage);
  }

  @override
  Widget build(BuildContext ctx) {
    _syncContactList();

    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          needToRefresh = true;
        });
      },
      child: Scaffold(
        appBar: _buildAppBar(ctx),
        body: RefreshIndicator(
          child: _buildBody(ctx),
          onRefresh: () {
            return _updateContactList();
          },
        ),
        floatingActionButton: _buildAddContactBtn(ctx),
      ),
    );
  }
}
