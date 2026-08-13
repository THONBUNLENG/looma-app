class UserModel {
  String id;
  String name;
  String gender;
  String dateOfBirth;
  String address;
  String photoUrl;
  String email;
  String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.photoUrl,
    this.email = "",
    this.phone = "",
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) => UserModel(
    id: id,
    name: json["name"] ?? "",
    gender: json["gender"] ?? "",
    dateOfBirth: json["dateOfBirth"] ?? json["age"] ?? "",
    address: json["address"] ?? "",
    photoUrl: json["photoUrl"] ?? json["picture"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "gender": gender,
    "dateOfBirth": dateOfBirth,
    "address": address,
    "photoUrl": photoUrl,
    "email": email,
    "phone": phone,
  };
}
