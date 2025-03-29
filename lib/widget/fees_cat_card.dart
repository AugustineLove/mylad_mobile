import 'package:flutter/material.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';

class FeesCatCard extends StatelessWidget {
  Color? cardColor;
  final String label;
  FeesCatCard({super.key, this.cardColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        color: cardColor ?? AppColors().primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: MyTexts().regularText(
          textAlign: TextAlign.center,
          "Pay \n$label",
          textColor: AppColors().whiteColor,
        ),
      ),
    );
  }
}
