

import 'package:dio/dio.dart';
import 'package:myladmobile/model/school.dart';

class SchoolService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:3000/api/schools/"));

  Future<List<School>> fetchSchools() async {
    try {
      final response = await _dio.get('/schools');
      List data = response.data;
      return data.map((school) => School.fromJson(school)).toList();
    } catch (e) {
      throw Exception("Failed to fetch schools");
    }
  }
}
