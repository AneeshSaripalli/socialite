import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socialite/models/contact.dart';
import 'package:socialite/widgets/contact.dart';
import 'package:socialite/widgets/search_bar.dart';

class ContactSearchPage extends StatefulWidget {
  final List<Contact> contactList;

  ContactSearchPage({@required this.contactList});

  @override
  State<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {
  String searchText = "";
  bool searching = false;

  List<Contact> displayList = [];

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
    List<Contact> filterList;
    if (searching) {
      filterList = widget.contactList.where((c) => _filterFunction(c)).toList();
    } else {
      filterList = [];
    }
    setState(() {
      displayList = filterList;
    });
  }

  @override
  @mustCallSuper
  void initState() {
    _updateFilterList();
    super.initState();
  }

  ListView _buildListView(BuildContext ctx) {
    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (BuildContext context, int index) {
        ContactWidget ret;

        if (Random().nextInt(2) == 0)
          ret = ContactWidget(
              contact: displayList[index],
              imgURL: 'https://source.unsplash.com/random/144x144');
        else
          ret = ContactWidget(
            contact: displayList[index],
          );

        return ret;
      },
    );
  }

  void _handleSearchTextChange(String queryText) {
    String removeSpaces =
        queryText.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
    setState(() {
      searchText = removeSpaces;
      searching = removeSpaces.length > 0;

      _updateFilterList();
    });
  }

  Widget _buildBody(BuildContext ctx) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 50, bottom: 10),
      child: Column(children: <Widget>[
        Text(
          "Search",
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 28.0, color: Colors.teal),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(5.0),
          child: SearchBar(
            onChanged: _handleSearchTextChange,
          ),
        ),
        Container(
            child: Expanded(
          child: _buildListView(ctx),
        ))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(displayList);
    return Scaffold(
      body: _buildBody(context),
    );
  }
}
