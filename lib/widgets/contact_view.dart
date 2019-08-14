import 'package:flutter/material.dart';
import 'package:socialite/external/firestore/firestore.dart';
import 'package:socialite/pages/modify_contact.dart';

import '../models/contact.dart';
import '../style/text_styles.dart';

class ContactViewPage extends StatefulWidget {
  final Contact contact;

  final GlobalKey key = GlobalKey(debugLabel: "ContactViewDismissibleKey");
  final String googleId;

  final VoidCallback editCallback;

  ContactViewPage(
      {@required this.contact, @required this.googleId, this.editCallback});

  @override
  State<ContactViewPage> createState() => _ContactViewPageState();
}

class _ContactViewPageState extends State<ContactViewPage> {
  // state variables related to FirestoreDB transaction status
  bool waitingOnDBResponse =
      false; // whether or not a transaction is currently in progress
  bool dbDeleteResponse; // signifies whether or not the db succeeded

  bool deletePressed = false;
  bool deleteConfirmed = false;

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

  void _handleEditBtnPress(BuildContext ctx) {
    print("want to edit");
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (ctx) => ModifyContactPage(
          contact: widget.contact,
          googleId: widget.googleId,
        ),
      ),
    ).then((value) {
      print(value);
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
            onPressed: () => _handleEditBtnPress(ctx),
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

  Widget _buildInfoPanel(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            'Mobile',
            style: label,
            textAlign: TextAlign.left,
          ),
          alignment: Alignment.center,
        ),
        Text(
          widget.contact.description,
          style: label,
        ),
        Text(
          widget.contact.phoneNumber,
          style: label,
        )
      ],
    );
  }

  Widget _buildShadedContainer(BuildContext ctx, Widget child) {
    return Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black38,
        ),
        child: child);
  }

  Widget _buildBody(BuildContext ctx) {
    return Center(
      child: Container(
        decoration: _buildBkgGradient(ctx),
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              _buildShadedContainer(ctx, _buildNamePanel(ctx)),
              SizedBox(
                height: 40,
              ),
              _buildShadedContainer(ctx, _buildInfoPanel(ctx))
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
        style: confirmContentStyle,
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

    Dismissible contactView = Dismissible(
        key: new GlobalKey(),
        direction: DismissDirection.startToEnd,
        onDismissed: (dir) {
          if (dir == DismissDirection.startToEnd) {
            Navigator.pop(ctx);
          }
        },
        child: body);

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
          Navigator.pop(ctx);
        } else {
          if (deletePressed) {
            setState(() {
              deletePressed = false;
            });
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(ctx),
        body: contactView,
      ),
    );
  }
}
