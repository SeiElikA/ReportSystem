import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:report_app/data/account.dart';
import 'package:report_app/model/login_model.dart';
import 'package:report_app/view/main_page.dart';
import 'package:report_app/view/adapt/main_page_adapt.dart';

import '../data/error_response.dart';
import '../global.dart';
import '../utils/utils.dart';

class LoginProvider with ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isShowPassword = false;
  var isLoading = false;

  void isShowPasswordClick() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void login(BuildContext context) async {
    var email = emailController.text;
    var password = passwordController.text;

    if(email.isEmpty) {
      showErrorDialog(context, "Email can't empty.");
      return;
    }

    if(password.isEmpty) {
      showErrorDialog(context, "Password can't empty.");
      return;
    }

    isLoading = true;
    notifyListeners();

    var model = LoginModel();
    try {
      final account = await model.login(email, password);
      await model.saveLoginInfo(account);
    } catch(ex) {
      print(ex);
      showErrorDialog(context, ex.toString().replaceAll("Exception:", ""));
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = false;
    notifyListeners();

    showSuccessfulDialog(context, "Login Successful", onTap: () {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainPageAdapt()), (page) => false);
    });
  }
}