import 'package:flutter/material.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  const SubmitButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors().primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTexts().titleText(
              label,
              textColor: AppColors().whiteColor,
            ),
          ),
        ));
  }
}
