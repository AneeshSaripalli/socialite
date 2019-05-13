import 'package:flutter/material.dart';
import 'package:socialite/database/firestore/firestore.dart';

import '../models/contact.dart';

class ContactView extends StatefulWidget {
  final Contact contact;

  final GlobalKey key = GlobalKey(debugLabel: "ContactViewDismissibleKey");

  ContactView({@required this.contact});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  // state variables related to FirestoreDB transaction status
  bool waitingOnDBResponse =
      false; // whether or not a transaction is currently in progress
  bool dbDeleteResponse; // signifies whether or not the db succeeded

  bool deletePressed = false;
  bool deleteConfirmed = false;

  final TextStyle overlayStyle =
      TextStyle(fontFamily: "Montserrat", fontSize: 24, color: Colors.green);

  final TextStyle appBarTitleStyle =
      TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 18.0);

  void _handleDeleteConfirmation(BuildContext ctx) async {
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
  }

  void _handleDeleteContactPress(BuildContext ctx) {
    print("Want to delete");
    setState(() {
      deletePressed = true;
    });
  }

  Widget _buildAppBar(BuildContext ctx) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        title: Text("View Homie", style: appBarTitleStyle),
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

    if (waitingOnDBResponse) {
      displayText = Text(
        "Waiting for DB Response",
        style: overlayStyle,
      );
    } else {
      if (dbDeleteResponse) {
        displayText = Text("Successfully deleted", style: overlayStyle);
      } else if (dbDeleteResponse == false) {
        displayText = Text("Failed to delete contact", style: overlayStyle);
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

  void _resetDeletePressed() {
    setState(() {
      deletePressed = false;
    });
  }

  AlertDialog _buildDeleteConfBox(BuildContext ctx) {
    final TextStyle confirm = TextStyle(
        fontFamily: 'Montserrat', color: Colors.green, fontSize: 18.0);

    final TextStyle deny =
        TextStyle(fontFamily: 'Montserrat', color: Colors.red, fontSize: 18.0);

    final TextStyle contentStyle = TextStyle(
        fontFamily: 'Montserrat', color: Colors.white, fontSize: 14.0);

    final TextStyle confirmTitleStyle =
        TextStyle(fontFamily: 'Montserrat', color: Colors.teal, fontSize: 18.0);

    return AlertDialog(
      title: Text(
        "Just makin' sure.",
        style: confirmTitleStyle,
      ),
      backgroundColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        "Are you sure you want to forget about Mr. Broseph " +
            widget.contact.lastName +
            "?",
        style: contentStyle,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Don't Delete",
            style: deny,
          ),
          onPressed: () => _resetDeletePressed(),
        ),
        FlatButton(
          child: Text("Confirm", style: confirm),
          onPressed: () {
            _resetDeletePressed();
            _handleDeleteConfirmation(ctx);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext ctx) {
    bool displayingOverlay = false;

    Stack body = Stack(children: <Widget>[_buildBody(ctx)]);

    if (waitingOnDBResponse || dbDeleteResponse != null) {
      body.children.add(_dbOverlay(ctx));
      displayingOverlay = true;
    } else if (deletePressed) {
      body.children.add(
        _buildDeleteConfBox(ctx),
      );
    }

    return GestureDetector(
      onTap: () {
        if (displayingOverlay) {
          print("Popping off");
          Navigator.pop(ctx);
        }
      },
      onHorizontalDragStart: (details) {
        print("Popping cause swipe");
        Navigator.pop(ctx);
      },
      child: Scaffold(
        appBar: _buildAppBar(ctx),
        body: Dismissible(
            key: new GlobalKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (dir) {
              if (dir == DismissDirection.startToEnd) {
                Navigator.pop(ctx);
              }
            },
            child: body),
      ),
    );
  }
}
