class StartStreamModel {
  final int accountId;
  final String name;
  final String description;
  final String layoutType;

  final int? id;
  final String? status;
  final String? startedAt;
  final String? endedAt;
  final String? createdAt;
  final String? updatedAt;
  final bool? isActive;

  StartStreamModel({
    required this.accountId,
    required this.name,
    required this.description,
    required this.layoutType,
    this.id,
    this.status,
    this.startedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      "account_id": accountId,
      "name": name,
      "description": description,
      "layout_type": layoutType,
    };
  }

  factory StartStreamModel.fromJson(Map<String, dynamic> json) {
    return StartStreamModel(
      id: json["id"],
      accountId: json["account_id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      layoutType: json["layout_type"] ?? "",
      status: json["status"],
      startedAt: json["started_at"],
      endedAt: json["ended_at"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      isActive: json["is_active"],
    );
  }
}