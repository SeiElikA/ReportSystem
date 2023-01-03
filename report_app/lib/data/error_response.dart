class ErrorResponse {
  String error = "";

  Map<String, dynamic> toJson() => {
    'error': error
  };

  ErrorResponse.fromJson(Map<String, dynamic> json)
      : error = json['error'];
}