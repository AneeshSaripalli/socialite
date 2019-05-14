// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:socialite/pages/contact_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
            "/": (ctx) => ContactPage(),
          },
        ));
    return obj;
  }
}
