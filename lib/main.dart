import 'package:flutter/material.dart';
import 'package:socialite/pages/contact_page.dart';

import "pages/add_contact.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Socialite',
      initialRoute: "/",
      routes: {
        "/": (ctx) => ContactPage(),
        "/add_contact": (ctx) => AddContactPage(),
      },
    );
  }
}
