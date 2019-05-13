import 'package:flutter/material.dart';
import 'package:socialite/style/text_styles.dart';

import '../database/firestore/firestore.dart';
import '../models/contact.dart';
import '../widgets/info_field_multi_line.dart';

/// AddContactPage Class
class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

/// State class for AddContact. Deals with TextField input & FirestoreDB transaction
class _AddContactPageState extends State<AddContactPage> {
  // input fields on screen.
  InfoFieldMultiLine _nameField; // contains full name of contact
  InfoFieldMultiLine _phoneField; // contains phone number for contact
  InfoFieldMultiLine _descriptionField; // contains description of person

  // state variables related to FirestoreDB transaction status
  bool waitingOnDBResponse =
      false; // whether or not a transaction is currently in progress
  bool dbResponseSuccess; // signifies whether or not the db succeeded

  _handleUploadPress(BuildContext context) async {
    setState(() {
      waitingOnDBResponse = true;
    });

    var nameSplit = _nameField.info.split(" ");

    String firstName, lastName;
    firstName = nameSplit.length != 0 ? nameSplit[0] : null;
    lastName = nameSplit.length > 0 ? nameSplit[1] : null;

    String phoneNumber = _phoneField.info;
    String desc = _descriptionField.info;

    String contactID = FirestoreDB().generateContactID();

    Contact contact = Contact(
      description: desc,
      firstName: firstName,
      lastName: lastName,
      id: contactID,
      phoneNumber: phoneNumber,
    );

    FirestoreDB().pushContactToContactsList(contact).then((ref) {
      setState(() {
        waitingOnDBResponse = false;
        dbResponseSuccess = true;
      });
    }).catchError((err) {
      setState(() {
        waitingOnDBResponse = false;
        dbResponseSuccess = false;
      });
    });
  }

  @override
  @mustCallSuper
  void initState() {
    _descriptionField = InfoFieldMultiLine(
      labelString: "Description",
      inputLabelString: "Enter Contact Description",
      hintString:
          "Met this bro at that Starbucks down the street. Likes surfing & strong espressos.",
      textInputType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      helperString: "Put a lil something to help remember them",
      prefixIcon: Icons.book,
    );

    _phoneField = InfoFieldMultiLine(
      inputLabelString: "Enter Phone Number.",
      labelString: "Phone #",
      textInputType: TextInputType.number,
      hintString: "5555555555",
      helperString: "A phone number if they've got one",
      prefixIcon: Icons.phone,
    );
    _nameField = InfoFieldMultiLine(
      inputLabelString: "Enter Name.",
      labelString: "Name",
      textInputType: TextInputType.text,
      hintString: "John Doe",
      helperString: "That there person's name",
      textCapitalization: TextCapitalization.words,
      prefixIcon: Icons.person,
    );

    super.initState();
  }

  Widget _buildSubmitButton(BuildContext context) {
    return RaisedButton(
      color: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textColor: Colors.white70,
      child: Icon(Icons.cloud_upload),
      onPressed: () => _handleUploadPress(context),
    );
  }

  Widget _buildInputForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: _nameField,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(5),
        ),
        Divider(color: Colors.white70),
        _phoneField,
        Divider(color: Colors.white70),
        SizedBox(height: 10),
        _descriptionField,
        Container(
          child: SizedBox(
            child: _buildSubmitButton(context),
            height: 50.0,
          ),
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        ),
      ],
    );
  }

  _handleHeartIconPress(BuildContext context) {
    print("Attempting to heart photo");
  }

  Widget _buildAppBar(BuildContext ctx) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        title: Text(
          "Add Contact",
          style: TextStyles.label,
        ),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => _handleHeartIconPress(context),
          )
        ],
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
      if (dbResponseSuccess) {
        displayText = Text("Successfully added", style: style);
      } else if (dbResponseSuccess == false) {
        displayText = Text("Failed to upload homeboy", style: style);
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

    Stack body = Stack(children: <Widget>[_buildInputForm(ctx)]);

    if (waitingOnDBResponse || dbResponseSuccess != null) {
      body.children.add(_dbOverlay(ctx));
      displayingOverlay = true;
    }

    return GestureDetector(
      onTap: () {
        if (displayingOverlay && dbResponseSuccess != null) {
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
