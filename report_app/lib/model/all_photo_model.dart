import 'dart:convert';

import 'package:report_app/data/image_resposne.dart';
import 'package:report_app/global.dart';
import 'package:http/http.dart' as http;

class AllPhotoModel {
  Future<List<ImageResponse>> getAllImage() async {
    var response = await http
        .get(Uri.parse("${baseUrl}getAllImage"),
            headers: {'Content-type': 'application/json'})
        .timeout(const Duration(seconds: 10))
        .onError((error, stackTrace) {
          throw Exception(error.toString());
        });

    List<dynamic> dataList = jsonDecode(response.body) as List;
    List<ImageResponse> resultList = [];
    dataList.forEach((element) {
      resultList.add(ImageResponse.fromJson(element));
    });
    return resultList;
  }
}
