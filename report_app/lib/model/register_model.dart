import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:report_app/data/error_response.dart';
import 'package:report_app/global.dart';

class RegisterModel {
  Future<void> register(String name, String email, String password) async {
    var response = await http.post(Uri.parse("${baseUrl}signUp"),
        headers: {
          'Content-type': 'application/json'
        },
        body: utf8.encode(jsonEncode({
          'name': name,
          'email': email,
          'password': password
        }))
    ).timeout(const Duration(seconds: 10));

    if(response.statusCode != 200) {
      var error = ErrorResponse.fromJson(jsonDecode(response.body));
      throw Exception(error.error);
    }
  }
}