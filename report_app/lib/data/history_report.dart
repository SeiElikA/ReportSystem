import 'package:report_app/data/account.dart';
import 'package:report_app/data/image_detail.dart';
import 'package:report_app/data/report_detail.dart';

class HistoryReport {
  int id = 0;
  String dateTime = "";
  Account? account;
  List<ReportDetail> reportDetail = [];
  List<ImageDetail> imageDetail = [];

  Map<String, dynamic> toJson() => {
        'id': id,
        "dateTime": dateTime,
        "account": account,
        "reportDetail": reportDetail,
        "imageDetail": imageDetail
      };

  HistoryReport.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateTime = json["dateTime"],
        account = Account.fromJson(json["account"]),
        reportDetail = (json["reportDetail"] as List)
            .map((e) => ReportDetail.fromJson(e))
            .toList(),
        imageDetail = (json["imageDetail"] as List)
            .map((e) => ImageDetail.fromJson(e))
            .toList();
}
