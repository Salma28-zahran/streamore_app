class StreamModel {
  final String name;
  final String description;
  final String layoutType;

  StreamModel({
    required this.name,
    required this.description,
    required this.layoutType,
  });

  factory StreamModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return StreamModel(
      name: json['name'] ?? '',
      description:
      json['description'] ?? '',
      layoutType:
      json['layout_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description":
      description,
      "layout_type":
      layoutType,
    };
  }
}