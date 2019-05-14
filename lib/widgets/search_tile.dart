import 'package:flutter/material.dart';
import 'package:socialite/style/text_styles.dart';

import './contact_view.dart';
import '../models/contact.dart';

class SearchTile extends StatelessWidget {
  final Contact contact;
  final String imgURL;

  final String googleId;

  final VoidCallback editCallback;

  final double iconRadius;
  final double buffer;

  SearchTile(
      {@required this.contact,
      @required this.googleId,
      this.iconRadius = 20,
      this.buffer = 10,
      this.imgURL,
      this.editCallback});

  // Handles contact press
  // Navigates to ContactView page displaying details on the Contact
  _handleContactBtnPress(BuildContext ctx) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) => ContactViewPage(
                  contact: contact,
                  googleId: googleId,
                  editCallback: editCallback,
                )));
  }

  @override
  Widget build(BuildContext ctx) {
    return RaisedButton(
      color: Colors.transparent,
      onPressed: () => _handleContactBtnPress(ctx),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
                radius: iconRadius,
                backgroundImage:
                    AssetImage("assets/images/unknown_contact_1.png")),
            SizedBox(
              width: buffer,
            ),
            Text(contact.firstName + " " + contact.lastName,
                style: searchTileLastNameStyle),
          ],
        ),
        subtitle: Row(children: <Widget>[
          SizedBox(
            width: 2 * iconRadius + buffer,
          ),
          Text(contact.phoneNumber,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                  color: Colors.white70,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid)),
        ]),
      ),
    );
  }
}
