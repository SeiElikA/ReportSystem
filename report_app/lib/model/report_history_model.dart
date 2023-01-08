import 'dart:convert';

import 'package:report_app/data/account.dart';
import 'package:http/http.dart' as http;
import 'package:report_app/data/history_report.dart';

import '../data/error_response.dart';
import '../global.dart';

class ReportHistoryModel {
  Future<List<Account>> getAllAccount() async {
    var response = await http
        .get(Uri.parse("${baseUrl}getAllAccount"),
            headers: {'Content-type': 'application/json'})
        .timeout(const Duration(seconds: 10))
        .onError((error, stackTrace) {
          throw Exception(error.toString());
        });

    List<dynamic> dataList = jsonDecode(response.body) as List;
    List<Account> resultList = [];
    dataList.forEach((element) {
      resultList.add(Account.fromJson(element));
    });
    return resultList;
  }

  Future<List<HistoryReport>> getAllReport() async {
    var response = await http
        .get(Uri.parse("${baseUrl}getAllReport"),
            headers: {'Content-type': 'application/json'})
        .timeout(const Duration(seconds: 10))
        .onError((error, stackTrace) {
          throw Exception(error.toString());
        });

    List<dynamic> dataList = jsonDecode(response.body) as List;
    List<HistoryReport> resultList = [];
    dataList.forEach((element) {
      resultList.add(HistoryReport.fromJson(element));
    });
    return resultList;
  }
}
