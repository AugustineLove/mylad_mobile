import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';

class StudentTransactionPage extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentTransactionPage(
      {super.key, required this.studentId, required this.studentName});

  @override
  State<StudentTransactionPage> createState() => _StudentTransactionPageState();
}

class _StudentTransactionPageState extends State<StudentTransactionPage> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final url = Uri.parse("${baseUrl}transactions/${widget.studentId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Cast and sort by date descending
        final sortedTransactions = data.cast<Map<String, dynamic>>();
        sortedTransactions.sort((a, b) {
          final dateA = DateTime.tryParse(a['date'] ?? '') ?? DateTime(1970);
          final dateB = DateTime.tryParse(b['date'] ?? '') ?? DateTime(1970);
          return dateB.compareTo(dateA); // latest first
        });

        setState(() {
          transactions = sortedTransactions;
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to fetch transactions.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }

  DataTable buildTransactionTable() {
    return DataTable(
      columns: [
        DataColumn(label: MyTexts().regularText("Date")),
        DataColumn(label: MyTexts().regularText("Type")),
        DataColumn(label: MyTexts().regularText("Amount")),
        DataColumn(label: MyTexts().regularText("Fee")),
      ],
      rows: transactions.map((tx) {
        final rawDate = tx["date"];
        String formattedDate;

        try {
          final parsedDate = DateTime.parse(rawDate);
          formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
        } catch (e) {
          formattedDate = rawDate;
        }

        return DataRow(cells: [
          DataCell(MyTexts().regularText(formattedDate)),
          DataCell(MyTexts().regularText(tx["transaction_type"] ?? '',
              textColor: tx['transaction_type'] == 'Credit'
                  ? AppColors().greenColor
                  : AppColors().redColor)),
          DataCell(MyTexts().regularText("GHS ${tx["amount"] ?? '0.00'}")),
          DataCell(MyTexts().regularText(tx["fee_type"] ?? '')),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors().whiteColor,
        elevation: 0,
        title: MyTexts().regularText(
          widget.studentName,
          textColor: AppColors().blackColor,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildTransactionTable(),
                    ),
                  ),
                ),
    );
  }
}
