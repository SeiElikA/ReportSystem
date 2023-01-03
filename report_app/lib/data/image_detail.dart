class ImageDetail {
  int id = 0;
  String imgPath = "";

  Map<String, dynamic> toJson() => {
    'id': id,
    "imgPath": imgPath
  };

  ImageDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imgPath = json["imgPath"];
}