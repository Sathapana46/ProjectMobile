class Item {
  int id;
  String name;
  String code;
  String type;
  String status;
  String location;
  String image;

  Item({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.status,
    required this.location,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      name: json["name"],
      code: json["code"],
      type: json["type"],
      status: json["status"],
      location: json["location"],
      image: json["image"] ?? "",
    );
  }
}
