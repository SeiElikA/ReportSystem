class Account {
  int id = 0;
  String name = "";
  String email = "";
  String password = "";

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password
  };

  Account.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json["name"],
        email = json["email"],
        password = json["password"];
}