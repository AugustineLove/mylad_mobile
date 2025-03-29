import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/student_page.dart';
import 'package:myladmobile/widget/child_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [
    Student(
        studentName: "Amazing Love Stephens",
        studentClass: "J.H.S 2",
        studentSchoolFees: 400,
        studentPTAFees: 100,
        studentExamFees: 120,
        studentAdmissionFees: 200,
        studentSportsFee: 50),
    Student(
        studentName: "Damiel Love Stephens",
        studentClass: "J.H.S 3",
        studentSchoolFees: 500, 
        studentPTAFees: 1280,
        studentExamFees: 140,
        studentAdmissionFees: 50,
        studentSportsFee: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors().whiteColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('GREENWOOD ACADEMY'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('WESTERN HAPPY HOME'),
              onTap: () {},
            ),
          ],
        ),
      ),
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
                    MyTexts().regularText("Welcome,"),
                    MyTexts().titleText("Mr. Stephens"),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          size: 12,
                        ),
                        MyTexts().regularText("Agona Fie - By Pass"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            20.0.vSpace,
            MyTexts().titleText(
              "Kids",
              textColor: AppColors().primaryColor,
            ),
            20.0.vSpace,
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final Student student = students[index];
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => StudentPage(
                                  student: student,
                                )));
                      },
                      child: ChildCard(
                        student: student,
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
