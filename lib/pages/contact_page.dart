import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:socialite/database/firestore/firestore.dart';
import 'package:socialite/widgets/contact_list.dart';
import 'package:socialite/widgets/search_bar.dart';

import '../models/contact.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contactList;
  List<Contact> displayList;
  bool needToRefresh = true;

  String searchText = "";

  List<Contact> genRandomContacts(int length) {
    List<Contact> cList = List<Contact>();

    for (int i = 0; i < length; ++i) {
      cList.add(Contact(
          description: randomString(200),
          lastName: randomString(10),
          firstName: randomString(10),
          id: randomString(10),
          name: randomString(20),
          phoneNumber: randomString(10)));
    }

    return cList;
  }

  PreferredSize _buildAppBar(BuildContext ctx) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        title: Text(
          "Homie List",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0),
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _handleAddContactPress(BuildContext ctx) {
    Navigator.pushNamed(ctx, '/add_contact').then((value) {
      print("Refreshing contact list after popping overlay");
      _updateContactList();
    });
  }

  FloatingActionButton _buildAddContactBtn(BuildContext ctx) {
    return FloatingActionButton(
      onPressed: () => _handleAddContactPress(ctx),
      backgroundColor: Colors.black54,
      child: Icon(
        Icons.add,
        color: Colors.teal,
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
    super.initState();
  }

  void _handleSearchTextChange(String queryText) {
    print(queryText);
    setState(() {
      print("Setting searchText to " + queryText);
      searchText = queryText;
      _updateFilterList();
    });
  }

  Widget _buildBody(BuildContext ctx) {
    Widget optionalContactList;

    if (contactList == null) {
      optionalContactList =
          Center(child: Container(child: CircularProgressIndicator()));
    } else {
      optionalContactList = Column(children: <Widget>[
        Container(
          child: SearchBar(onChanged: _handleSearchTextChange),
          margin: EdgeInsets.only(bottom: 10, top: 5, left: 3, right: 3),
        ),
        Expanded(child: ContactList(contacts: displayList))
      ]);
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(colors: [Colors.black, Colors.teal]),
        ),
        child: optionalContactList);
  }

  bool _filterFunction(Contact c) {
    final bool firstName =
        c.firstName.toLowerCase().contains(searchText.toLowerCase());
    final bool lastName =
        c.lastName.toLowerCase().contains(searchText.toLowerCase());
    final bool phoneNumber =
        c.phoneNumber.toLowerCase().contains(searchText.toLowerCase());

    return firstName || lastName || phoneNumber;
  }

  void _updateFilterList() {
    print("Filtering with search " + searchText);
    List<Contact> filterList =
        this.contactList.where((c) => _filterFunction(c)).toList();
    setState(() {
      displayList = filterList;
    });
  }

  Future<void> _updateContactList() async {
    print("Update contact list called");

    List<Map<String, dynamic>> dbData = await FirestoreDB().getContactsFromDB();
    List<Contact> contactList = dbData.map((record) {
      return Contact.fromMap(record);
    }).toList();

    setState(() {
      this.contactList = contactList;
      _updateFilterList();
    });
  }

  @override
  void didUpdateWidget(ContactPage oldPage) {
    super.didUpdateWidget(oldPage);
  }

  @override
  Widget build(BuildContext ctx) {
    _syncContactList();

    return Scaffold(
      appBar: _buildAppBar(ctx),
      body: RefreshIndicator(
        child: _buildBody(ctx),
        onRefresh: () {
          return _updateContactList();
        },
      ),
      floatingActionButton: _buildAddContactBtn(ctx),
    );
  }
}
