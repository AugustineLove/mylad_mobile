import 'package:flutter/material.dart';

class Student extends ChangeNotifier {
  final String studentId;
  final String studentSurname;
  final String studentClassName;
  final String schoolName;
  final String studentAddress;
  final String studentParentFirstName;
  String? studentOtherNames;
  final String studentParentSurname;
  final String studentParentNumber;
  final String studentFirstName;
  final String schoolWebsite;
  final String schoolEmail;
  String? schoolSubAccountCode;
  String? studentParentEmail;
  List<Fee> fees;

  Student({
    required this.studentId,
    required this.studentSurname,
    required this.studentClassName,
    required this.schoolName,
    required this.studentAddress,
    required this.studentParentFirstName,
    this.studentOtherNames,
    required this.studentParentSurname,
    required this.studentParentNumber,
    required this.studentFirstName,
    required this.schoolWebsite,
    required this.schoolEmail,
    this.schoolSubAccountCode,
    this.studentParentEmail,
    required this.fees,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'] ?? '', // ✅ Uses correct key
      studentSurname: json['student_surname'] ?? 'Unknown',
      studentClassName: json['student_class_name'] ?? 'Unknown',
      schoolName: (json['school_name'] ?? ''), // ✅ Fixes object issue
      studentAddress: json['student_address'] ?? 'No Address',
      studentParentFirstName: json['student_parent_first_name'] ?? 'Unknown',
      studentOtherNames: json['student_other_names'] ?? '',
      studentParentSurname: json['student_parent_surname'] ?? 'Unknown',
      studentParentNumber: json['student_parent_number'] ?? '',
      studentFirstName: json['student_first_name'] ?? '',
      schoolWebsite: json['school_website'] ?? '',
      schoolEmail: json['school_email'] ?? '',
      schoolSubAccountCode: json['subaccount_code'],
      studentParentEmail: json['student_parent_email'],
      fees: (json['fees'] as List?)
              ?.map((fee) => Fee.fromJson(fee as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  void updateFees(List<Fee> newFees) {
    fees = newFees;
    notifyListeners(); // Triggers UI rebuild
  }
}

class School {
  final String id;
  final String name;

  School({required this.id, required this.name});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown School',
    );
  }
}

class Fee {
  final String feeType;
  final double amount;
  final String status;

  Fee({
    required this.feeType,
    required this.amount,
    required this.status,
  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      feeType: json['feetype'] ?? 'Unknown Fee',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'unknown',
    );
  }
}
