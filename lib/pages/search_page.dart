import 'package:flutter/material.dart';
import 'package:socialite/models/contact.dart';
import 'package:socialite/widgets/search_bar.dart';
import 'package:socialite/widgets/search_tile.dart';

import '../style/text_styles.dart';

class ContactSearchPage extends StatefulWidget {
  final List<Contact> contactList;
  final String googleId;

  ContactSearchPage({@required this.contactList, @required this.googleId});

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

  final double iconRadius = 20;
  final double buffer = 10;

  Widget _buildListTile(BuildContext ctx, int index) {
    final Contact contact = displayList[index];

    return SearchTile(contact: contact, googleId: widget.googleId);
  }

  ListView _buildListView(BuildContext ctx) {
    final array = [
      Colors.yellow,
      Colors.pink,
      Colors.green,
      Colors.teal,
      Colors.red
    ];

    return ListView.builder(
        itemCount: displayList.length,
        itemBuilder: (BuildContext context, int index) {
          Color gradientColor = array[index % array.length];

          return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white54),
                gradient:
                    LinearGradient(colors: [Colors.black87, gradientColor]),
              ),
              child: Column(
                children: <Widget>[
                  _buildListTile(ctx, index),
                ],
              ));
        });
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
      margin: EdgeInsets.only(top: 50, bottom: 10.0),
      child: Column(children: <Widget>[
        Text(
          "Search",
          style: headerStyle,
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(5.0),
          child: SearchBar(
            onChanged: _handleSearchTextChange,
          ),
        ),
        Divider(
          color: Colors.white,
          height: 10,
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
