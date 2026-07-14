class StartStreamModel {
  final int accountId;
  final String name;
  final String description;
  final String layoutType;

  final int? id;
  final String? status;
  final String? startedAt;
  final String? endedAt;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  final bool? isActive;

  final dynamic durationSeconds;
  final dynamic canStart;
  final dynamic canEnd;
  final dynamic canArchive;
  final dynamic connectedDestinationsCount;

  StartStreamModel({
    required this.accountId,
    required this.name,
    required this.description,
    required this.layoutType,
    this.id,
    this.status,
    this.startedAt,
    this.endedAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.durationSeconds,
    this.canStart,
    this.canEnd,
    this.canArchive,
    this.connectedDestinationsCount,
  });

  Map<String, dynamic> toJson() {
    return {
      "account_id": accountId,
      "name": name,
      "description": description,
      "layout_type": layoutType,
    };
  }

  factory StartStreamModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return StartStreamModel(
      id: json["id"],
      accountId: json["account_id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      layoutType: json["layout_type"] ?? "",
      status: json["status"],
      startedAt: json["started_at"],
      endedAt: json["ended_at"],
      deletedAt: json["deleted_at"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      isActive: json["is_active"],
      durationSeconds: json["duration_seconds"],
      canStart: json["can_start"],
      canEnd: json["can_end"],
      canArchive: json["can_archive"],
      connectedDestinationsCount:
      json["connected_destinations_count"],
    );
  }
}