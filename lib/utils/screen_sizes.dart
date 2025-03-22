import 'package:flutter/material.dart';

class Screen {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double textScaleFactor(BuildContext context) =>
      MediaQuery.of(context).textScaleFactor;

  static double pixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  static double statusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double bottomBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  static double safeAreaTop(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double safeAreaBottom(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;
}
