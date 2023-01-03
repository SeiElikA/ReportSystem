import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:report_app/data/report.dart';
import 'package:report_app/model/main_model.dart';
import 'package:report_app/utils/utils.dart';
import 'package:report_app/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider extends ChangeNotifier {
  var reportList = <Report>[];
  var isLoading = false;

  Future<void> setReportList(BuildContext context, {bool showLoading = true}) async {
    final accountId = (await SharedPreferences.getInstance()).getInt("id") ?? 0;
    final model = MainModel();

    if(!showLoading) {
      isLoading = true;
      notifyListeners();
    }

    try {
      reportList.clear();
      reportList = await model.getReportList(accountId);
      notifyListeners();
    } catch(ex) {
      showErrorDialog(context, ex.toString());
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logoutClick(BuildContext context) async {
    Navigator.of(context).pop();

    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.clear();

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
  }
}