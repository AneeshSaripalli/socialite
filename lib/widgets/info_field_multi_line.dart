import 'package:flutter/material.dart';
import 'package:socialite/style/text_styles.dart';

class InfoFieldMultiLine extends StatefulWidget {
  final String labelString;
  final String inputLabelString;
  final String hintString;
  final String helperString;
  final String initialText;

  final IconData prefixIcon;

  final TextInputType textInputType;

  final int maxLength;
  final bool autocorrect;

  final TextCapitalization textCapitalization;

  String _infoData = "";

  FocusNode nextFocus;

  InfoFieldMultiLine({
    @required this.labelString,
    @required this.inputLabelString,
    @required this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = false,
    this.maxLength = 200,
    this.textInputType = TextInputType.text,
    this.helperString = 'Keep it short, this is just a demo.',
    this.hintString = 'Tell us about yourself',
    this.initialText = "",
    this.nextFocus,
  });

  String get info {
    return _infoData;
  }

  @override
  _InfoFieldStateMultiLine createState() {
    return _InfoFieldStateMultiLine();
  }
}

class _InfoFieldStateMultiLine extends State<InfoFieldMultiLine> {
  TextEditingController _controller;

  void onChange(String newString) {
    setState(() {
      print("new value " + newString);
      widget._infoData = newString;
    });
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialText);
    widget._infoData = widget.initialText;
    super.initState();
  }

  Widget _buildMultiLine(
      BuildContext context, Widget descriptor, Widget input) {
    return Column(
      children: <Widget>[
        Container(
          child: descriptor,
          alignment: Alignment.topLeft,
        ),
        input,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget descriptor = Text(widget.labelString, style: TextStyles.label);
    final Widget input = TextField(
      controller: _controller,
      onChanged: (String s) {
        onChange(s);
      },
      onSubmitted: (String submission) {
        print("Submitted " + submission);
        widget.nextFocus != null
            ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.nextFocus = null;
      },
      keyboardType: widget.textInputType,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      maxLines: null,
      style: TextStyle(
          color: Colors.white, fontFamily: 'Montserrat', fontSize: 14),
      decoration: new InputDecoration(
        hintText: widget.hintString,
        helperText: widget.helperString,
        labelText: widget.labelString,
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.green,
        ),
      ),
    );

    return _buildMultiLine(context, descriptor, input);
  }
}
