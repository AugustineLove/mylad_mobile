import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/screen_sizes.dart';
import 'package:myladmobile/utils/text.dart';

class FeesCatCard extends StatelessWidget {
  Color? cardColor;
  IconData? icon;
  final String label;
  FeesCatCard({super.key, this.cardColor, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width(context) * 0.7,
      height: 70,
      decoration: BoxDecoration(
        color: cardColor ?? AppColors().primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors().whiteColor),
            10.0.hSpace,
            MyTexts().regularText(
              textAlign: TextAlign.center,
              label,
              textColor: AppColors().whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
