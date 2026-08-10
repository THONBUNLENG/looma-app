class UserModel {
  String id;
  String name;
  String gender;
  String age;
  String address;
  String picture;
  String email;
  String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.address,
    required this.picture,
    this.email = "",
    this.phone = "",
  });

  factory UserModel.fromJson(String id,Map<String, dynamic> json) => UserModel(
    id: id,
    name: json["name"] ?? "",
    gender: json["gender"] ?? "",
    age: json["age"] ?? "",
    address: json["address"] ?? "",
    picture: json["picture"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "gender": gender,
    "age": age,
    "address": address,
    "picture": picture,
    "email": email,
    "phone": phone,
  };
}
