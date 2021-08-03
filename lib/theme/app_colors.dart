import 'package:flutter/material.dart';

const Color darkBackgroundColor = Color(0xFF121212);
const Color lightBackgroundColor = Colors.white;

const Color darkCardColor = Color(0xFF393939);
final Color lightCardColor = Color(0xFF393939).withOpacity(0.1);

const Color white = Colors.white;
const Color black = Colors.black;

const Color gold = Color(0xFFfcfa23c);

extension ColorSchemeEx on ColorScheme {
  Color get backgroundColor => brightness == Brightness.dark
      ? darkBackgroundColor
      : lightBackgroundColor;
  Color get toolbarColor => brightness == Brightness.dark
      ? darkBackgroundColor
      : lightBackgroundColor;
}