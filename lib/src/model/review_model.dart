class ReviewModel {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String>? images;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
    this.images,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "userImage": userImage,
        "rating": rating,
        "comment": comment,
        "date": date.toIso8601String(),
        "images": images,
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        userName: json["userName"],
        userImage: json["userImage"],
        rating: json["rating"].toDouble(),
        comment: json["comment"],
        date: DateTime.parse(json["date"]),
        images: json["images"] != null ? List<String>.from(json["images"]) : null,
      );
}
