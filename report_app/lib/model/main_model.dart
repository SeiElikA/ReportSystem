import 'dart:convert';

import '../data/error_response.dart';
import '../data/report.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

class MainModel {
  Future<List<Report>> getReportList(int accountId) async {
    var response = await http.post(Uri.parse("${baseUrl}getReport"),
        headers: {
          'Content-type': 'application/json'
        },
        body: utf8.encode(jsonEncode({
          'accountId': accountId
        }))
    ).timeout(const Duration(seconds: 10));

    if(response.statusCode != 200) {
      var error = ErrorResponse.fromJson(jsonDecode(response.body));
      throw Exception(error.error);
    }

    final result = <Report>[];
    List<dynamic> dataList = jsonDecode(response.body);
    for (var element in dataList) {
      result.add(Report.fromJson(element));
    }
    return result;
  }
}