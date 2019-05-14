import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import 'package:socialite/database/firestore/firestore.dart';
import 'package:socialite/pages/modify_contact.dart';
import 'package:socialite/pages/search_page.dart';
import 'package:socialite/style/text_styles.dart';
import 'package:socialite/widgets/contact_list.dart';

import '../models/contact.dart';
import 'auth_page.dart';

class ContactPage extends StatefulWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contactList;
  bool needToRefresh = true;

  bool signInActive = false;
  GoogleSignInAccount _account;

  GoogleAuthWidget signIn;

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
          style: appBarTitleStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("Fuzzy search pressed");
              _handleSearchPress(ctx);
            },
          )
        ],
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _handleSearchPress(BuildContext ctx) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) => ContactSearchPage(
                  contactList: contactList,
                  googleId: _account.id,
                )));
  }

  void _handleAddContactPress(BuildContext ctx) {
    Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (ctx) => ModifyContactPage(googleId: _account.id)))
        .then((value) {
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

    if (!signInActive) {
      signIn = GoogleAuthWidget(
        googleSignIn: widget._googleSignIn,
        signInCallBack: _handleSignIn,
      );
      signInActive = true;
    }
    super.initState();
  }

  void _handleEditCallback() {
    print("Edit called");
    setState(() {
      _syncContactList();
    });
  }

  Widget _buildBody(BuildContext ctx) {
    Widget optionalContactList;

    if (contactList == null || _account == null) {
      optionalContactList =
          Center(child: Container(child: CircularProgressIndicator()));
    } else {
      optionalContactList = ContactList(
        contacts: contactList,
        googleId: _account.id,
        editCallback: _handleEditCallback,
      );
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(colors: [Colors.black, Colors.teal]),
        ),
        child: optionalContactList);
  }

  Future<void> _updateContactList() async {
    if (_account != null) {
      List<Map<String, dynamic>> dbData =
          await FirestoreDB().getContactsFromDB(_account.id);
      List<Contact> contactList = dbData.map((record) {
        return Contact.fromMap(record);
      }).toList();

      setState(() {
        this.contactList = contactList;
      });
    } else {
      setState(() {
        this.contactList = [];
      });
    }
  }

  @override
  void didUpdateWidget(ContactPage oldPage) {
    super.didUpdateWidget(oldPage);
  }

  void _handleSignIn(GoogleSignInAccount acc) {
    print(acc.id);
    setState(() {
      _account = acc;
      _updateContactList();
    });
  }

  void _handleSignOut(VoidCallback postSignOut) {
    widget._googleSignIn.signOut().then((acc) => postSignOut());
  }

  @override
  Widget build(BuildContext ctx) {
    _syncContactList();

    Stack pageContent = Stack(
      children: <Widget>[],
    );

    if (_account == null) {
      pageContent.children.add(signIn);
    }
    Widget contactPageWidget = WillPopScope(
      onWillPop: () {
        print("popping");
        _handleSignOut(() {
          print("Signin out");
          SystemNavigator.pop();
        });
      },
      child: Scaffold(
        appBar: _buildAppBar(ctx),
        body: RefreshIndicator(
          child: _buildBody(ctx),
          onRefresh: () {
            return _updateContactList();
          },
        ),
        floatingActionButton: _buildAddContactBtn(ctx),
      ),
    );

    pageContent.children.add(contactPageWidget);
    return pageContent;
  }
}
