import 'dart:math';

import "package:flutter/material.dart";

import "../models/contact.dart";
import '../widgets/contact.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contacts;

  ContactList({@required this.contacts});

  ListView _buildContactList(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        ContactWidget ret;

        if (Random().nextInt(2) == 0)
          ret = ContactWidget(
              contact: contacts[index],
              imgURL: 'https://source.unsplash.com/random/144x144');
        else
          ret = ContactWidget(
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
