import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef void SignInCallback(GoogleSignInAccount acc);

class GoogleAuthWidget extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  GoogleAuthWidget(
      {@required this.signInCallBack, @required this.googleSignIn});

  final SignInCallback signInCallBack;

  @override
  State<GoogleAuthWidget> createState() => _GoogleAuthWidgetState();
}

class _GoogleAuthWidgetState extends State<GoogleAuthWidget> {
  @override
  void initState() {
    super.initState();
    widget.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) {
      widget.signInCallBack(account);
    });
  }

  Future<void> _handleSignIn(BuildContext ctx) async {
    print("Handling sign in");
    try {
      print("Trying to sign in");
      await widget.googleSignIn.signIn();
      print(widget.googleSignIn.currentUser);
    } catch (error) {
      print("Sign in failed");
      print(error);
    }
  }

  Widget _buildBody() {}

  @override
  Widget build(BuildContext context) {
    _handleSignIn(context);

    return Center(
        child: Container(
      child: Text(
        "Google Sign In",
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 28, color: Colors.teal),
      ),
      color: Colors.white10,
    ));
  }
}
