import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactView extends StatefulWidget {
  final Contact contact;

  ContactView({@required this.contact});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  Widget _buildAppBar(BuildContext ctx) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        title: Text("View Contact Details",
            style: TextStyle(
                fontFamily: 'Montserrat', color: Colors.white, fontSize: 18.0)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print("Want to edit");
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildBody(BuildContext ctx) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(colors: [Colors.black, Colors.teal]),
        ),
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black38,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.contact.firstName,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 36,
                          color: Colors.teal),
                    ),
                    Text(widget.contact.lastName,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(appBar: _buildAppBar(ctx), body: _buildBody(ctx));
  }
}
