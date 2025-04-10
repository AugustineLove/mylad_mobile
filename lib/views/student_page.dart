import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/select_feeType_toPay.dart';
import 'package:myladmobile/widget/fees_card.dart';
import 'package:myladmobile/widget/fees_cat_card.dart';
import 'package:provider/provider.dart';

class StudentPage extends StatefulWidget {
  final Student initialStudent;

  const StudentPage({super.key, required this.initialStudent});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late Student selectedStudent;

  @override
  void initState() {
    super.initState();
    selectedStudent = widget.initialStudent;
  }

  void _showStudentSwitcher(BuildContext context, List<Student> students) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors().whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTexts().titleText("Switch child", fontSize: 18),
              10.0.vSpace,
              ...students.map((student) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors().blueColor,
                    child: MyTexts().regularText(
                      student.studentFirstName[0],
                      textColor: AppColors().whiteColor,
                    ),
                  ),
                  title: MyTexts().regularText(
                      '${student.studentFirstName} ${student.studentSurname}'),
                  subtitle: MyTexts().regularText(student.schoolName),
                  onTap: () {
                    setState(() {
                      selectedStudent = student;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
      builder: (context, parentProvider, child) {
        List<Student> students = parentProvider.students;

        // Ensure the selected student stays updated if changes occur
        if (!students.contains(selectedStudent) && students.isNotEmpty) {
          selectedStudent = students.first;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors().whiteColor,
            actions: [
              IconButton(
                icon: Icon(Icons.person, color: AppColors().primaryColor),
                onPressed: () => _showStudentSwitcher(context, students),
              ),
            ],
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
                        color: AppColors().blueColor,
                      ),
                      child: Center(
                        child: MyTexts().titleText(
                          selectedStudent.studentFirstName[0],
                          textColor: AppColors().whiteColor,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    20.0.hSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTexts().titleText(
                            '${selectedStudent.studentFirstName} ${selectedStudent.studentSurname}'),
                        MyTexts().regularText(selectedStudent.schoolName),
                        MyTexts().regularText(selectedStudent.studentClassName),
                      ],
                    ),
                  ],
                ),
                20.0.vSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...selectedStudent.fees.map((fee) {
                      return FeesCard(
                        label: fee.feeType,
                        feeAmount: fee.amount,
                      );
                    }).toList(),
                    20.0.vSpace,
                    FeesCard(
                      label: "Total",
                      feeAmount: selectedStudent.fees
                          .fold(0.0, (sum, fee) => sum + fee.amount),
                      textColor: AppColors().redColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                20.0.vSpace,
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => FeeToPay(
                              studentName: selectedStudent.studentFirstName,
                            )));
                  },
                  child: Center(
                    child: FeesCatCard(
                      label: "Pay Fees",
                      cardColor: AppColors().primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
