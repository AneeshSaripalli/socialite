import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef void SignOutCallback(GoogleSignInAccount acc);

class GoogleSignoutWidget extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  final SignOutCallback signOutCallback;

  GoogleSignoutWidget(
      {@required this.googleSignIn, @required this.signOutCallback});

  State<GoogleSignoutWidget> createState() => _GoogleSignoutWidgetState();
}

class _GoogleSignoutWidgetState extends State<GoogleSignoutWidget> {
  bool signedOut = false;

  @override
  void initState() {
    widget.googleSignIn.signOut().then(widget.signOutCallback);

    print(widget.googleSignIn.isSignedIn().then(print));
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      child: Text('hi'),
    );
  }
}
