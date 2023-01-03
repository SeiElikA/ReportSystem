import 'dart:convert';
import 'dart:io';

import 'package:gallery_saver/files.dart';
import 'package:image_picker/image_picker.dart';
import 'package:report_app/global.dart';
import 'package:http/http.dart' as http;

import '../data/error_response.dart';

class AddReportModel {
  Future<void> sendReport(int accountId, List<XFile> imgList, List<String> workItemList) async {
    var postData = <dynamic>[];
    for (var e in workItemList) {
      postData.add({
        "content": e
      });
    }
    print(jsonEncode(postData));

    var response = await http.post(Uri.parse("${baseUrl}sendReport"),
        headers: {
          'Content-type': 'application/json'
        },
        body: utf8.encode(jsonEncode({
          'accountId': accountId,
          'data': postData
        }))
    ).timeout(const Duration(seconds: 10));

    if(response.statusCode != 200) {
      var error = ErrorResponse.fromJson(jsonDecode(response.body));
      throw Exception(error.error);
    }

    print(imgList);
    if(imgList.isEmpty) return;

    int reportId = jsonDecode(response.body)["reportId"];
    var postUri = Uri.parse("${baseUrl}uploadImg?reportId=$reportId");
    var request = http.MultipartRequest("POST", postUri);
    for (var element in imgList) {
      request.files.add(http.MultipartFile.fromBytes('image', File(element.path).readAsBytesSync(), filename: element.name));
    }

    request.send().then((response) {
      if(response.statusCode != 200) {
        throw Exception("Upload Error");
      }
    });
  }
}