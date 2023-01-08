import 'package:flutter/material.dart';
import 'package:report_app/data/image_resposne.dart';
import 'package:report_app/model/all_photo_model.dart';
import 'package:report_app/utils/utils.dart';

class AllPhotoProvider extends ChangeNotifier {
  var model = AllPhotoModel();
  List<ImageResponse> allImage = [];
  var isLoading = false;

  Future<void> getAllImage(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      allImage = await model.getAllImage();
    } catch (e) {
      showErrorDialog(context, e.toString());
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }
}
