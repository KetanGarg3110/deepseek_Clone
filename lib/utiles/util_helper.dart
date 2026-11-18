import 'package:flutter/material.dart';

class AppColors {
  static const Color bgColor = Color(0xff101010);
  static const Color secondaryColor = Color(0xff202023);
  static const Color mGreyColor = Color(0xff9E9E9E);
  static const Color whiteColor = Colors.white;
}

TextStyle mTextStyle16({
  Color mColor = Colors.black,
  FontWeight mFontWeight = FontWeight.normal,
}) {
  // in this we putting the default text styles .
  return TextStyle(
    fontSize: 16,
    fontFamily: 'mainFont', // pub.yaml se font lege
    color: mColor,
    fontWeight: mFontWeight,
  );
}

TextStyle mTextStyle25({
  // heading
  Color mColor = Colors.black,
  FontWeight mFontWeight = FontWeight.normal,
}) {
  // in this we putting the default text styles .
  return TextStyle(
    fontSize: 25,
    fontFamily: 'mainFont', // pub.yaml se font lege
    color: mColor,
    fontWeight: mFontWeight,
  );
}

TextStyle mTextStyle12({
  // time
  Color mColor = Colors.black,
  FontWeight mFontWeight = FontWeight.normal,
}) {
  // in this we putting the default text styles .
  return TextStyle(
    fontSize: 12,
    fontFamily: 'mainFont', // pub.yaml se font lege
    color: mColor,
    fontWeight: mFontWeight,
  );
}
