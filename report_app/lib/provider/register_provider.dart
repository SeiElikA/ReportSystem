import 'dart:io';

import 'package:flutter/material.dart';
import 'package:report_app/model/register_model.dart';
import 'package:report_app/utils/utils.dart';

class RegisterProvider with ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var nameController = TextEditingController();
  var isShowPassword = false;
  var isLoading = false;

  void isShowPasswordClick() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  Future<void> registerClick(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    var model = RegisterModel();
    var name = nameController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var confirmPassword = confirmPasswordController.text;

    // check content
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      showErrorDialog(context, "Email format not correct");
      return;
    }

    if(name.isEmpty) {
      showErrorDialog(context, "Name can't empty");
      return;
    }

    if(password.length < 8) {
      showErrorDialog(context, "Your password is too easy");
      return;
    }

    if(password != confirmPassword) {
      showErrorDialog(context, "Your password not match");
      return;
    }

    try {
      await model.register(name, email, password);
    }catch(ex) {
      showErrorDialog(context, ex.toString());
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = false;
    notifyListeners();

    showSuccessfulDialog(context, "Register Successful", onTap: () {
      Navigator.of(context).pop();
    });
  }
}
