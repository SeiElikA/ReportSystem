import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_app/data/history_report.dart';
import 'package:report_app/data/report.dart';
import 'package:report_app/model/report_history_model.dart';
import 'package:report_app/utils/utils.dart';

import '../data/account.dart';

class ReportHistoryProvider extends ChangeNotifier {
  var model = ReportHistoryModel();
  List<HistoryReport> dataList = [];
  List<HistoryReport> filterList = [];
  List<String> accountList = [];
  List<String> dateTimeList = []; // use filter filter list
  List<String> dropDownDateTimeList = []; // use show in drop down button
  String accountSelection = "All";
  String dateTimeSelection = "All";
  var isLoading = false;

  Future<void> getAllData(BuildContext context) async {
    isLoading = true;
    accountList.clear();
    dataList.clear();
    notifyListeners();

    accountList.add("All");

    try {
      accountList
          .addAll((await model.getAllAccount()).map((e) => e.name).toList());
      dataList = await model.getAllReport();
      filterList = dataList;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      showErrorDialog(context, e.toString());
      return;
    }

    dateTimeList = [
      ...{...dataList.map((e) => e.dateTime).toList()}
    ];

    dateTimeList.sort(((a, b) {
      var dateFormat = DateFormat("yyyy-MM-dd");
      var first = dateFormat.parse(a);
      var second = dateFormat.parse(b);
      return second.compareTo(first);
    }));

    dropDownDateTimeList.addAll(dateTimeList);
    dropDownDateTimeList.insert(0, "All");

    isLoading = false;
    notifyListeners();
  }
}
