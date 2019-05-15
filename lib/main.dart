// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialite/pages/contact_page.dart';

void main() => runApp(MyApp());

// TODO
// Fuzzy Search
// Birthday Sync to Google Calendar
// Choosing themes in the application
class MyApp extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/calendar'
    ],
  );

  @override
  Widget build(BuildContext context) {
    WillPopScope obj = WillPopScope(
        onWillPop: () {
          print("Popping main app");
          dynamic result = Navigator.of(context);

          print(result.toString());
        },
        child: MaterialApp(
          theme: ThemeData.dark(),
          title: 'Socialite',
          initialRoute: "/",
          routes: {
            "/": (ctx) => ContactPage(
                  googleSignIn: _googleSignIn,
                ),
          },
        ));
    return obj;
  }
}
