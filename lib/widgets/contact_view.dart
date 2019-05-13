import 'package:flutter/material.dart';
import 'package:socialite/database/firestore/firestore.dart';

import '../models/contact.dart';

class ContactView extends StatefulWidget {
  final Contact contact;

  ContactView({@required this.contact});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  // state variables related to FirestoreDB transaction status
  bool waitingOnDBResponse =
      false; // whether or not a transaction is currently in progress
  bool dbDeleteResponse; // signifies whether or not the db succeeded

  void _handleDeleteContactPress(BuildContext ctx) async {
    print("Want to delete");
    setState(() {
      waitingOnDBResponse = true;
    });

    FirestoreDB().deleteContactFromDB(widget.contact.id).then((res) {
      print("Respose received " + res.toString());
      setState(() {
        waitingOnDBResponse = false;
        dbDeleteResponse = res;
      });
    });

    print(widget.contact.toMap().toString());
  }

  Widget _buildAppBar(BuildContext ctx) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        title: Text("View Contact",
            style: TextStyle(
                fontFamily: 'Montserrat', color: Colors.white, fontSize: 18.0)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print("Want to edit");
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _handleDeleteContactPress(ctx);
            },
          )
        ],
        backgroundColor: Colors.teal,
      ),
    );
  }

  BoxDecoration _buildBkgGradient(BuildContext ctx) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      gradient: LinearGradient(colors: [Colors.black, Colors.teal]),
    );
  }

  Widget _buildNamePanel(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Text(
          widget.contact.firstName,
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 36, color: Colors.teal),
        ),
        Text(widget.contact.lastName,
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 24, color: Colors.white70)),
      ],
    );
  }

  Widget _buildBody(BuildContext ctx) {
    return Center(
      child: Container(
        decoration: _buildBkgGradient(ctx),
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
                child: _buildNamePanel(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dbOverlay(BuildContext ctx) {
    Text displayText;

    TextStyle style =
        TextStyle(fontFamily: "Montserrat", fontSize: 24, color: Colors.green);

    if (waitingOnDBResponse) {
      displayText = Text(
        "Waiting for DB Response",
        style: style,
      );
    } else {
      if (dbDeleteResponse) {
        displayText = Text("Successfully deleted", style: style);
      } else if (dbDeleteResponse == false) {
        displayText = Text("Failed to delete contact", style: style);
      }
    }

    return Center(
      child: SizedBox.expand(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          color: Colors.black54,
          child: Center(child: displayText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    bool displayingOverlay = false;

    Stack body = Stack(children: <Widget>[_buildBody(ctx)]);

    if (waitingOnDBResponse || dbDeleteResponse != null) {
      body.children.add(_dbOverlay(ctx));
      displayingOverlay = true;
    }

    return GestureDetector(
      onTap: () {
        if (displayingOverlay) {
          Navigator.pop(ctx);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(ctx),
        body: body,
      ),
    );
  }
}
