import 'package:flutter/material.dart';

class Student extends ChangeNotifier {
  final String studentId;
  final String studentName;
  final String studentClassName;
  final String schoolName;
  final String studentAddress;
  final String studentParentName;
  final String studentParentNumber;
  List<Fee> fees;

  Student({
    required this.studentId,
    required this.studentName,
    required this.studentClassName,
    required this.schoolName,
    required this.studentAddress,
    required this.studentParentName,
    required this.studentParentNumber,
    required this.fees,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'] ?? '', // ✅ Uses correct key
      studentName: json['studentName'] ?? 'Unknown',
      studentClassName: json['studentClassName'] ?? 'Unknown',
      schoolName: (json['schoolName'] ?? ''), // ✅ Fixes object issue
      studentAddress: json['studentAddress'] ?? 'No Address',
      studentParentName: json['studentParentName'] ?? 'Unknown',
      studentParentNumber: json['studentParentNumber'] ?? '',
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
      feeType: json['feeType'] ?? 'Unknown Fee',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'unknown',
    );
  }
}
