import 'package:flutter/material.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';

class FeesCard extends StatelessWidget {
  final String label;
  final double feeAmount;
  Color? textColor;
  FontWeight? fontWeight;
  FeesCard(
      {super.key,
      required this.label,
      required this.feeAmount,
      this.textColor,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: AppColors().strokeColor,
          )),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              MyTexts().regularText(label,
                  textColor: textColor, fontWeight: fontWeight),
              const Spacer(),
              MyTexts().regularText("$feeAmount", fontWeight: fontWeight)
            ],
          ),
        ));
  }
}
