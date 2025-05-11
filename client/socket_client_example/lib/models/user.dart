class User {
  final String name;
  final int id;

  const User({required this.name, required this.id});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"] ?? "",
        id: int.tryParse(json["id"]) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
