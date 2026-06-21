class StreamModel {
  final int? id;
  final int? accountId;
  final String? name;
  final String? description;
  final String? layoutType;

  StreamModel({
    this.id,
    this.accountId,
    this.name,
    this.description,
    this.layoutType,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      id: json['id'],
      accountId: json['account_id'],
      name: json['name'],
      description: json['description'],
      layoutType: json['layout_type'],
    );
  }
}