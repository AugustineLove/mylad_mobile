import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/hubtel_merchante_pay.dart';
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
                    backgroundColor: AppColors().primaryColor.withOpacity(0.9),
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

        if (!students.contains(selectedStudent) && students.isNotEmpty) {
          selectedStudent = students.first;
        }

        double totalFee =
            selectedStudent.fees.fold(0.0, (sum, fee) => sum + fee.amount);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors().whiteColor,
            elevation: 0,
            title: MyTexts().titleText(
              "Ward Info",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              IconButton(
                icon: Icon(FeatherIcons.users, color: AppColors().primaryColor),
                onPressed: () => _showStudentSwitcher(context, students),
              ),
            ],
          ),
          backgroundColor: AppColors().whiteColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 Header Avatar
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors().primaryColor,
                      child: MyTexts().titleText(
                        selectedStudent.studentFirstName[0],
                        textColor: AppColors().whiteColor,
                        fontSize: 24,
                      ),
                    ),
                    20.0.hSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTexts().titleText(
                          '${selectedStudent.studentFirstName} ${selectedStudent.studentSurname}',
                          fontSize: 18,
                        ),
                        MyTexts().regularText(selectedStudent.schoolName),
                        MyTexts().regularText(
                            "Class: ${selectedStudent.studentClassName}"),
                      ],
                    ),
                  ],
                ),
                30.0.vSpace,

                // 🔥 Fees Summary Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors().whiteColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTexts().titleText("Fee Breakdown", fontSize: 16),
                      12.0.vSpace,
                      ...selectedStudent.fees.map((fee) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: FeesCard(
                            label: fee.feeType,
                            feeAmount: fee.amount,
                          ),
                        );
                      }).toList(),
                      FeesCard(
                        label: "Total Due",
                        feeAmount: totalFee,
                        textColor: AppColors().redColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                30.0.vSpace,

                // 🔥 Action Card
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => HubtelCheckoutPage(
                          student: selectedStudent,
                          parent: selectedStudent, // Adjust if different model
                          feeType: "Tuition",
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: FeesCatCard(
                      label: "Pay Now",
                      cardColor: AppColors().primaryColor,
                      icon: FeatherIcons.creditCard,
                    ),
                  ),
                ),
                30.0.vSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
