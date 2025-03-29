import 'package:flutter/material.dart';
import 'package:myladmobile/model/school.dart';
import 'package:myladmobile/services/schoolServices.dart';
class SchoolProvider with ChangeNotifier {
  List<School> _schools = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<School> get schools => _schools;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSchools() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schools = await SchoolService().fetchSchools();
    } catch (e) {
      _errorMessage = "Error fetching schools";
    }

    _isLoading = false;
    notifyListeners();
  }
}
