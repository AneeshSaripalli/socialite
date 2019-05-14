import 'dart:math';

import "package:flutter/material.dart";

import "../models/contact.dart";
import '../widgets/contact.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contacts;

  final String googleId;

  final VoidCallback editCallback;

  ContactList(
      {@required this.contacts, @required this.googleId, this.editCallback});

  ListView _buildContactList(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        ContactWidget ret;

        if (Random().nextInt(2) == 0)
          ret = ContactWidget(
              googleId: googleId,
              contact: contacts[index],
              imgURL: 'https://source.unsplash.com/random/144x144');
        else
          ret = ContactWidget(
            googleId: googleId,
            contact: contacts[index],
          );

        return ret;
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return _buildContactList(ctx);
  }
}
