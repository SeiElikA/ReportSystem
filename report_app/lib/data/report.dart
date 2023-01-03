import 'package:report_app/data/image_detail.dart';
import 'package:report_app/data/report_detail.dart';

class Report {
  int id = 0;
  String dateTime = "";
  List<ReportDetail> reportDetail = [];
  List<ImageDetail> imageDetail = [];

  Map<String, dynamic> toJson() => {
    'id': id,
    "dateTime": dateTime,
    "reportDetail": reportDetail,
    "imageDetail": imageDetail
  };

  Report.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateTime = json["dateTime"],
        reportDetail = (json["reportDetail"] as List).map((e) => ReportDetail.fromJson(e)).toList(),
        imageDetail = (json["imageDetail"] as List).map((e) => ImageDetail.fromJson(e)).toList();
}