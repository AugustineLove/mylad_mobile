import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/screen_sizes.dart';
import 'package:myladmobile/utils/text.dart';

class SchoolCard extends StatefulWidget {
  final String schoolName;
  final String schoolMoto;
  final String schoolLogo;
  Color? borderColor;

  SchoolCard({
    super.key,
    required this.schoolName,
    required this.schoolMoto,
    required this.schoolLogo,
    this.borderColor,
  });

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width(context) * 0.7,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: widget.borderColor ?? AppColors().strokeColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Make the image flexible if necessary
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors().primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: MyTexts().regularText(widget.schoolName[0],
                    textColor: AppColors().whiteColor),
              ),
            ),
            10.0.hSpace, // Reduce space for better fit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTexts().titleText(
                    widget.schoolName,
                    overflow: TextOverflow.ellipsis, // Prevents overflow
                  ),
                  MyTexts().regularText(
                    widget.schoolMoto,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true, // Allows text wrapping
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
