import 'package:flutter/material.dart';

extension Spacing on double {
  Widget get hSpace => SizedBox(width: this);
  Widget get vSpace => SizedBox(height: this);
}
