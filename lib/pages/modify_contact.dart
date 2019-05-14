import 'package:flutter/material.dart';
import 'package:socialite/style/text_styles.dart';

import '../database/firestore/firestore.dart';
import '../models/contact.dart';
import '../widgets/info_field_multi_line.dart';

/// AddContactPage Class
class ModifyContactPage extends StatefulWidget {
  final Contact contact;

  final String googleId;

  ModifyContactPage({@required this.googleId, this.contact});

  @override
  _ModifyContactPageState createState() => _ModifyContactPageState();
}

/// State class for AddContact. Deals with TextField input & FirestoreDB transaction
class _ModifyContactPageState extends State<ModifyContactPage> {
  // input fields on screen.
  InfoFieldMultiLine _nameField; // contains full name of contact
  InfoFieldMultiLine _phoneField; // contains phone number for contact
  InfoFieldMultiLine _descriptionField; // contains description of person
  InfoFieldMultiLine _emailField;

  String _initialName;
  String _initialPhone;
  String _initialDesc;
  String _initialEmail;

  // state variables related to FirestoreDB transaction status
  bool waitingOnDBResponse =
      false; // whether or not a transaction is currently in progress
  bool dbResponseSuccess; // signifies whether or not the db succeeded

  bool dataChanged = false;

  bool displayBackConfirmation = false;

  _handleUploadPress(BuildContext context) async {
    setState(() {
      waitingOnDBResponse = true;
    });

    var nameSplit = _nameField.info.split(" ");

    String name = _nameField.info;

    String firstName, lastName;
    firstName = nameSplit.length != 0 ? nameSplit[0] : null;
    lastName = nameSplit.length > 0 ? nameSplit[1] : null;

    String phoneNumber = _phoneField.info;
    String desc = _descriptionField.info;

    String contactID = widget.contact == null
        ? FirestoreDB().generateContactID()
        : widget.contact.id;

    String email = _emailField.info;

    Contact contact = Contact(
      name: name,
      description: desc,
      firstName: firstName,
      lastName: lastName,
      id: contactID,
      phoneNumber: phoneNumber,
      email: email,
    );

    FirestoreDB()
        .pushContactToContactsList(contact, widget.googleId)
        .then((ref) {
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

  void _initializeInputFieldsWithInitialValues() {
    _initialName = widget.contact.name;
    _initialPhone = widget.contact.phoneNumber;
    _initialDesc = widget.contact.description;
    _initialEmail = widget.contact.email;

    _descriptionField = InfoFieldMultiLine(
      labelString: "Description",
      inputLabelString: "Enter Contact Description",
      hintString:
          "Met this bro at that Starbucks down the street. Likes surfing & strong espressos.",
      textInputType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      helperString: "Put a lil something to help remember them",
      prefixIcon: Icons.book,
      initialText: widget.contact.description,
    );

    _phoneField = InfoFieldMultiLine(
      inputLabelString: "Enter Phone Number.",
      labelString: "Phone #",
      textInputType: TextInputType.number,
      hintString: "5555555555",
      helperString: "A phone number if they've got one",
      prefixIcon: Icons.phone,
      initialText: widget.contact.phoneNumber,
    );
    _nameField = InfoFieldMultiLine(
      inputLabelString: "Enter Name.",
      labelString: "Name",
      textInputType: TextInputType.text,
      hintString: "John Doe",
      helperString: "That there person's name",
      textCapitalization: TextCapitalization.words,
      prefixIcon: Icons.person,
      initialText: widget.contact.firstName + " " + widget.contact.lastName,
    );
    _emailField = InfoFieldMultiLine(
      inputLabelString: "Enter Email.",
      labelString: "Email",
      textInputType: TextInputType.emailAddress,
      hintString: "johndoe@gmail.com",
      helperString: "Homie's email",
      textCapitalization: TextCapitalization.words,
      prefixIcon: Icons.email,
      initialText: widget.contact.email,
    );
  }

  void _initialInputFieldsWithoutInitialValues() {
    _initialPhone = _initialName = _initialEmail = _initialDesc = "";

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
    _emailField = InfoFieldMultiLine(
      inputLabelString: "Enter Email.",
      labelString: "Email",
      textInputType: TextInputType.text,
      hintString: "johndoe@gmail.com",
      helperString: "Homie's email",
      textCapitalization: TextCapitalization.words,
      prefixIcon: Icons.email,
    );
  }

  @override
  @mustCallSuper
  void initState() {
    widget.contact == null
        ? _initialInputFieldsWithoutInitialValues()
        : _initializeInputFieldsWithInitialValues();

    super.initState();
  }

  Widget _buildSubmitButton(BuildContext context) {
    IconData iconImg = widget.contact == null ? Icons.cloud_upload : Icons.edit;

    return RaisedButton(
      color: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textColor: Colors.white70,
      child: Icon(iconImg),
      onPressed: () => _handleUploadPress(context),
    );
  }

  bool _evaluateDataChanged() {
    bool changed = false;

    final bool descChanged = _initialDesc != _descriptionField.info;
    final bool emailChanged = _initialEmail != _emailField.info;
    final bool nameChanged = _initialName != _nameField.info;
    final bool phoneChanged = _initialPhone != _phoneField.info;

    print(
        "Desc $descChanged, Email $emailChanged, Name $nameChanged, Phone $phoneChanged");

    changed = descChanged || emailChanged || nameChanged || phoneChanged;

    return changed;
  }

  Widget _buildInputForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: _nameField,
          padding: EdgeInsets.all(5),
        ),
        Divider(color: Colors.white70),
        SizedBox(height: 10),
        Container(
          child: _phoneField,
          padding: EdgeInsets.all(5),
        ),
        Divider(color: Colors.white70),
        SizedBox(height: 10),
        Container(
          child: _emailField,
          padding: EdgeInsets.all(5),
        ),
        Divider(color: Colors.white70),
        SizedBox(height: 10),
        Container(
          child: _descriptionField,
          padding: EdgeInsets.all(5),
        ),
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
          style: label,
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
        displayText = widget.contact == null
            ? Text("Successfully added", style: style)
            : Text("Successfully edited", style: style);
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

  Future<bool> _handleOnWillPop(BuildContext ctx) async {
    bool response;
    if (_evaluateDataChanged() && !displayBackConfirmation) {
      setState(() {
        dataChanged = true;
        displayBackConfirmation = true;
      });

      response = false;
    } else {
      response = true;
    }

    return response;
  }

  AlertDialog _buildUnsavedChangesWarning(BuildContext ctx) {
    return AlertDialog(
      title: Text(
        "Just checkin'",
        style: confirmTitleStyle,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.black87,
      content: Text(
        "You have some unsaved changes. Are you sure you want to leave?",
        style: confirmContentStyle,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Leave anyway", style: deny),
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
        ),
        FlatButton(
          child: Text("Stay", style: confirm),
          onPressed: () {
            setState(() {
              displayBackConfirmation = false;
            });
          },
        )
      ],
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

    if (displayBackConfirmation) {
      AlertDialog confirmBack = _buildUnsavedChangesWarning(ctx);
      body.children.add(confirmBack);
    }

    return WillPopScope(
        onWillPop: () {
          return _handleOnWillPop(ctx);
        },
        child: GestureDetector(
          onTap: () {
            if (displayingOverlay && dbResponseSuccess != null) {
              Navigator.of(ctx).pop(dataChanged);
            }
          },
          child: Scaffold(
            appBar: _buildAppBar(ctx),
            body: body,
          ),
        ));
  }
}
