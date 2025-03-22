import 'package:flutter/material.dart';

class MyTexts {
  Text regularText(
    String text, {
    Color? textColor,
    double? fontSize,
    bool? softWrap,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      softWrap: softWrap ?? true,
      style: TextStyle(
        fontSize: fontSize ?? 12,
        fontFamily: 'Poppins',
        color: textColor,
        overflow: overflow,
      ),
    );
  }

  Text titleText(
    String text, {
    Color? textColor,
    double? fontSize,
    bool? softWrap,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      softWrap: softWrap ?? true,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 15,
        fontFamily: 'Poppins',
        color: textColor,
        overflow: overflow,
      ),
    );
  }
}
