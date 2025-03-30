import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';

class ChildCard extends StatelessWidget {
  final Student student;
  const ChildCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors().blueColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: MyTexts().titleText(student.studentName[0],
                    textColor: AppColors().whiteColor),
              )),
          20.0.hSpace,
          Expanded(
            // This prevents overflow
            child: Container(
              decoration: BoxDecoration(
                color: AppColors().whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: AppColors().greyColor.withOpacity(0.5),
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTexts()
                            .regularText(student.studentName, fontSize: 14),
                        MyTexts().regularText(student.studentClassName),
                      ],
                    ),
                    const Spacer(), // Prevent overflow issue
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
