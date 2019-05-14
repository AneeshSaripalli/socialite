import 'package:flutter/material.dart';

import './contact_view.dart';
import '../models/contact.dart';

class ContactWidget extends StatelessWidget {
  final Contact contact;
  final String imgURL;

  final String googleId;

  final VoidCallback editCallback;

  ContactWidget(
      {@required this.contact,
      @required this.googleId,
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
    ImageProvider img = imgURL == null
        ? AssetImage('assets/images/unknown_contact_1.png')
        : NetworkImage(imgURL);

    return Container(
      margin:
          const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          RaisedButton(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white12,
            onPressed: () {
              _handleContactBtnPress(ctx);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: <Widget>[
                CircleAvatar(radius: 20, backgroundImage: img
                    //                       AssetImage("assets/images/unknown_contact_2.png")
                    ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  contact.lastName,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.teal,
                      fontSize: 18.0),
                ),
                Text(", " + contact.firstName,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white54,
                        fontSize: 18.0)),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            height: 10,
          ),
        ],
      ),
    );
  }
}
