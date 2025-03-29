import 'package:flutter/material.dart';

class MyTexts {
  Text regularText(
    String text, {
    Color? textColor,
    double? fontSize,
    bool? softWrap,
    TextOverflow? overflow,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      softWrap: softWrap ?? true,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize ?? 12,
        fontFamily: 'Poppins',
        color: textColor,
        overflow: overflow,
        fontWeight: fontWeight,
      ),
    );
  }

  Text titleText(
    String text, {
    Color? textColor,
    double? fontSize,
    bool? softWrap,
    TextOverflow? overflow,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) {
    return Text(
      text,
      softWrap: softWrap ?? true,
      textAlign: textAlign,
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
