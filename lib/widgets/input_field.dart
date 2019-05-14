import 'package:flutter/material.dart';

abstract class InputField extends InheritedWidget {
  final String labelString;
  final String inputLabelString;
  final String hintString;
  final String helperString;

  final IconData prefixIcon;

  final TextInputType textInputType;

  final int maxLength;
  final bool autocorrect;

  final TextCapitalization textCapitalization;

  String _infoData = "";

  final FocusNode nextFocus;

  InputField({
    @required this.labelString,
    @required this.inputLabelString,
    @required this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = false,
    this.maxLength = 200,
    this.textInputType = TextInputType.text,
    this.helperString = 'Keep it short, this is just a demo.',
    this.hintString = 'Tell us about yourself',
    this.nextFocus,
  });

  String get info {
    return _infoData;
  }
}
