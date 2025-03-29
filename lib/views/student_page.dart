import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/pay_fees.dart';
import 'package:myladmobile/widget/fees_card.dart';
import 'package:myladmobile/widget/fees_cat_card.dart';

class StudentPage extends StatefulWidget {
  final Student student;
  const StudentPage({super.key, required this.student});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  Map<String, Color> feeCatCard = {
    'School Fees': AppColors().primaryColor,
    'PTA Fees': AppColors().yellowColor,
    'Admission Fees': AppColors().redColor,
    'Sports Fees': AppColors().blueColor,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().whiteColor,
      ),
      backgroundColor: AppColors().whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors().greyColor,
                  ),
                ),
                20.0.hSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTexts().titleText(widget.student.studentName),
                    MyTexts().regularText("Greenwood Academy,"),
                    MyTexts().regularText(widget.student.studentClass),
                  ],
                ),
              ],
            ),
            20.0.vSpace,
            FeesCard(
                label: "School Fees",
                feeAmount: widget.student.studentSchoolFees),
            FeesCard(
                label: "PTA Dues", feeAmount: widget.student.studentPTAFees),
            FeesCard(
                label: "Exam Fees", feeAmount: widget.student.studentExamFees),
            FeesCard(
                label: "Admission Fees",
                feeAmount: widget.student.studentAdmissionFees),
            FeesCard(
                label: "Sport Fees",
                feeAmount: widget.student.studentSportsFee),
            FeesCard(
              label: "Total",
              feeAmount: widget.student.studentSchoolFees +
                  widget.student.studentPTAFees +
                  widget.student.studentExamFees +
                  widget.student.studentAdmissionFees +
                  widget.student.studentSportsFee,
              textColor: AppColors().redColor,
              fontWeight: FontWeight.bold,
            ),
            20.0.vSpace,
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: feeCatCard.length,
                itemBuilder: (context, index) {
                  final String feeCat = feeCatCard.keys.elementAt(index);
                  final Color cardColor = feeCatCard.values.elementAt(index);
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => PayFees(
                                  category: feeCat,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FeesCatCard(
                          label: feeCat,
                          cardColor: cardColor,
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
