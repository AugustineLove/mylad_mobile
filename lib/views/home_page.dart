import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/student.dart';
import 'package:myladmobile/provider/parentProvider.dart';
import 'package:myladmobile/services/studentsServices.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/initial_page.dart';
import 'package:myladmobile/views/student_page.dart';
import 'package:myladmobile/widget/child_card.dart';
import 'package:myladmobile/widget/school_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool showEmailInput = false;
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _startAutoRefresh();
  }

  Timer? _refreshTimer;

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final box = await Hive.openBox('user');
      final phoneNumber = box.get('phoneNumber');
      if (phoneNumber != null) {
        await fetchAndStoreStudents(context, phoneNumber);
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _loadStudents() async {
    final box = await Hive.openBox('user');
    final phoneNumber = box.get('phoneNumber');
    if (phoneNumber != null) {
      await fetchAndStoreStudents(context, phoneNumber);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateEmail(String email, List<String> studentIds) async {
    logger.d(studentIds);
    await updateStudentParentEmail(studentIds, email);
    final box = await Hive.openBox('user');
    final phoneNumber = box.get('phoneNumber');
    if (phoneNumber != null) {
      await fetchAndStoreStudents(context, phoneNumber);
    }
    setState(() {
      showEmailInput = false;
    });
  }

  Future<void> _logout() async {
    final box = await Hive.openBox('user');
    await box.delete('phoneNumber');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const InitialPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parentProvider = Provider.of<ParentProvider>(context);
    final students = parentProvider.students;
    final parent = students.isNotEmpty ? students.first : null;

    // Grouping students by school name
    Map<String, List<Student>> groupedStudents = {};
    for (var student in students) {
      groupedStudents.putIfAbsent(student.schoolName, () => []).add(student);
    }

    List<String> allStudentIds = students.map((e) => e.studentId).toList();

    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors().whiteColor,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _logout,
              child: Icon(
                Icons.logout,
                color: AppColors().redColor,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (parent != null) ...[
                    // Parent Information Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors().primaryColor,
                          child: MyTexts().titleText(
                            parent.studentParentSurname[0],
                            textColor: AppColors().whiteColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTexts().regularText("Welcome,"),
                              MyTexts().titleText(
                                "Mr/Mrs. ${parent.studentParentSurname} ${parent.studentParentFirstName}",
                                fontWeight: FontWeight.w600,
                              ),
                              MyTexts().regularText(
                                parent.studentParentNumber,
                                fontSize: 14,
                                textColor: Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              // Email Input or Display
                              if (parent.studentParentEmail == null)
                                showEmailInput
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: emailController,
                                              decoration: const InputDecoration(
                                                hintText: "Enter email",
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final email =
                                                  emailController.text.trim();
                                              if (email.isNotEmpty) {
                                                _updateEmail(
                                                    email, allStudentIds);
                                              }
                                            },
                                            icon: const Icon(Icons.save),
                                          ),
                                        ],
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showEmailInput = true;
                                          });
                                        },
                                        child: Text(
                                          "Add email",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: AppColors().primaryColor,
                                          ),
                                        ),
                                      )
                              else
                                MyTexts().regularText(
                                  parent.studentParentEmail!,
                                  textColor: Colors.green[700],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                  // Children Section
                  MyTexts().titleText(
                    "Your Children",
                    textColor: AppColors().primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: students.isEmpty
                        ? const Center(child: Text("No students found."))
                        : ListView(
                            children: groupedStudents.entries.map((entry) {
                              final schoolName = entry.key;
                              final children = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // School Card Section
                                    SchoolCard(
                                      schoolName: schoolName,
                                      schoolMoto: children.first.schoolEmail,
                                      schoolLogo:
                                          "schoolLogo", // Add logo URL or asset
                                    ),
                                    const SizedBox(height: 16),
                                    // Children Cards
                                    ...children.map((student) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (_) => StudentPage(
                                                initialStudent: student,
                                              ),
                                            ),
                                          );
                                        },
                                        child: ChildCard(student: student),
                                      );
                                    }).toList(),
                                  ],
                                ),
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
