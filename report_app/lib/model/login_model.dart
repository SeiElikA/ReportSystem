import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:report_app/data/error_response.dart';
import 'package:report_app/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';

class LoginModel {
  Future<Account> login(String email, String password) async {
    var response = await http.post(Uri.parse("${baseUrl}login"),
        headers: {
          'Content-type': 'application/json'
        },
        body: utf8.encode(jsonEncode({
          'email': email,
          'password': password
        }))
    ).timeout(const Duration(seconds: 10));

    if(response.statusCode != 200) {
      var error = ErrorResponse.fromJson(jsonDecode(response.body));
      throw Exception(error.error);
    }
    var account = Account.fromJson(jsonDecode(response.body));
    return account;
  }

  Future<void> saveLoginInfo(Account account) async {
    await SharedPreferences.getInstance()
      ..setInt("id", account.id)
      ..setString("name", account.name)
      ..setString("email", account.email)
      ..setString("password", account.password)
      ..setBool("isLogin", true);
  }
}