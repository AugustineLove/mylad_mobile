import 'package:dio/dio.dart';
import 'package:myladmobile/model/school.dart';
import 'package:myladmobile/utils/constants.dart';

class SchoolService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: "http://192.168.15.29:3000/api/schools"));

  Future<List<School>> fetchSchools() async {
    try {
      final response = await _dio.get('/');
      List data = response.data;
      logger.d(data);
      return data.map((school) => School.fromJson(school)).toList();
    } catch (e) {
      throw Exception("Failed to fetch schools");
    }
  }
}
