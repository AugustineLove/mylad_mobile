import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/student_page.dart';
import 'package:myladmobile/widget/child_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final parentProvider = Provider.of<ParentProvider>(context);
    final students = parentProvider.students;

    // Group students by school
    Map<String, List<Student>> groupedStudents = {};
    for (var student in students) {
      groupedStudents.putIfAbsent(student.schoolName, () => []).add(student);
    }

    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors().whiteColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors().lightGrey,
                    shape: BoxShape.circle,
                  ),
                ),
                20.0.hSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTexts().regularText("Welcome,"),
                    if (students.isNotEmpty)
                      MyTexts().titleText(
                        'Mr, ${students.first.studentParentName}',
                        fontWeight: FontWeight.bold,
                      ),
                  ],
                ),
              ],
            ),
            40.0.vSpace,
            MyTexts().titleText("Kids", textColor: AppColors().primaryColor),
            20.0.vSpace,
            Expanded(
              child: students.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: groupedStudents.entries.map((entry) {
                        String schoolName = entry.key;
                        List<Student> schoolStudents = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTexts().titleText(
                              schoolName,
                              textColor: AppColors().blackColor,
                            ),
                            10.0.vSpace,
                            ...schoolStudents.map((student) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => StudentPage(
                                        initialStudent: student,
                                      ),
                                    ),
                                  );
                                },
                                child: ChildCard(student: student),
                              );
                            }).toList(),
                            20.0.vSpace, // Space between schools
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
