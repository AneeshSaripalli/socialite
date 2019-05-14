import 'package:flutter/material.dart';
import 'package:socialite/style/text_styles.dart';

class InfoFieldSingleLine extends StatefulWidget {
  final String labelString;
  final String inputLabelString;
  final String hintString;
  final String helperString;

  final TextCapitalization textCapitalization;

  final TextInputType textInputType;

  final IconData prefixIcon;

  final bool autocorrect;

  String _infoData = "";

  InfoFieldSingleLine({
    @required this.labelString,
    @required this.inputLabelString,
    @required this.prefixIcon,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = false,
    this.helperString = 'Keep it short, this is just a demo.',
    this.hintString = 'Tell us about yourself',
  });

  String get info {
    return _infoData;
  }

  @override
  _InfoFieldState createState() {
    return _InfoFieldState();
  }
}

class _InfoFieldState extends State<InfoFieldSingleLine> {
  void onChange(String newString) {
    setState(() {
      print("new value " + newString);
      widget._infoData = newString;
    });
  }

  @override
  void initState() {}

  Widget _buildSingleLine(
      BuildContext context, Widget descriptor, Widget sep, Widget input) {
    return Row(
      children: <Widget>[descriptor, sep, input],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget descriptor = Text(widget.labelString, style: label);
    final Widget input = Expanded(
      child: TextField(
        onChanged: (String s) {
          print("on change?");
          onChange(s);
        },
        keyboardType: widget.textInputType,
        textCapitalization: widget.textCapitalization,
        autocorrect: widget.autocorrect,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(
              borderSide:
                  new BorderSide(color: Theme.of(context).primaryColor)),
          hintText: widget.hintString,
          helperText: widget.helperString,
          labelText: widget.labelString,
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.green,
          ),
        ),
      ),
    );

    final Widget sep = Container(
        height: 30.0,
        width: 2.0,
        color: Colors.teal,
        margin: const EdgeInsets.symmetric(horizontal: 12.0));

    return _buildSingleLine(context, descriptor, sep, input);
  }
}
