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

  final int alpha = 150;

  ListView _buildListView(BuildContext ctx) {
    final array = [
      Colors.green.withAlpha(alpha),
      Colors.yellow.withAlpha(alpha),
      Colors.pink.withAlpha(alpha),
      Colors.teal.withAlpha(alpha),
      Colors.deepPurple.withAlpha(alpha),
      Colors.orange.withAlpha(alpha),
      Colors.red.withAlpha(alpha),
      Colors.blue.withAlpha(alpha),
    ];

    return ListView.builder(
        itemCount: displayList.length,
        itemBuilder: (BuildContext context, int index) {
          Color gradientColor = array[index % array.length];

          return Column(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(color: Colors.white54),
                gradient:
                    LinearGradient(colors: [Colors.black87, gradientColor]),
              ),
              child: Column(
                children: <Widget>[
                  _buildListTile(ctx, index),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            )
          ]);
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
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black12, Colors.black87])),
      margin: EdgeInsets.only(top: 50, bottom: 10.0),
      child: Column(children: <Widget>[
        Text(
          "Search",
          style: headerStyle,
        ),
        SizedBox(height: 10),
        Container(
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
