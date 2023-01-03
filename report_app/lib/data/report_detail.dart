class ReportDetail {
  int id = 0;
  String content = "";

  Map<String, dynamic> toJson() => {
    'id': id,
    "content": content
  };

  ReportDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json["content"];
}