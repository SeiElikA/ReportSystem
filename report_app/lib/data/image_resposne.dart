class ImageResponse {
  int id = 0;
  String imgPath = "";
  int reportContentId = 0;

  Map<String, dynamic> toJson() =>
      {'id': id, 'imgPath': imgPath, 'reportContentId': reportContentId};

  ImageResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imgPath = json["imgPath"],
        reportContentId = json["reportContentId"];
}
