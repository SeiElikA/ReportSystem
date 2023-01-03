import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:report_app/model/add_report_model.dart';
import 'package:report_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReportProvider extends ChangeNotifier {
  var uploadImg = <XFile>[];
  var workItem = <String>[];
  var workItemController =  TextEditingController();
  var isLoading = false;

  void addWorkItem(BuildContext context) {
    final item = workItemController.text;
    if(item.isEmpty) {
      showErrorDialog(context, "Work item can't empty.");
      return;
    }

    if(workItem.contains(item)) {
      showErrorDialog(context, "This work item is exist.");
      return;
    }

    workItem.add(item);
    notifyListeners();

    workItemController.text = "";
  }

  Future<void> sendReport(BuildContext context) async {
    if(workItem.isEmpty) {
      showErrorDialog(context, "You must be add a work item at least");
      return;
    }

    final model = AddReportModel();
    final accountId = (await SharedPreferences.getInstance()).getInt("id") ?? 0;

    isLoading = true;
    notifyListeners();

    try {
      await model.sendReport(accountId, uploadImg, workItem);
    } catch(ex) {
      showErrorDialog(context, ex.toString().replaceAll("Exception:", ""));
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = false;
    notifyListeners();

    showSuccessfulDialog(context, "Send Successful", onTap: () async {
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context).pop();
    });
  }
}