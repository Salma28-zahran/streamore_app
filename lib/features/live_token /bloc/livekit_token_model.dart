class LiveKitTokenModel {
  final int id;
  final int accountId;
  final String name;
  final String description;
  final String status;
  final String layoutType;
  final String startedAt;
  final String endedAt;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;
  final bool isActive;
  final String durationSeconds;
  final String canStart;
  final String canEnd;
  final String canArchive;
  final String connectedDestinationsCount;

  LiveKitTokenModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.description,
    required this.status,
    required this.layoutType,
    required this.startedAt,
    required this.endedAt,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.durationSeconds,
    required this.canStart,
    required this.canEnd,
    required this.canArchive,
    required this.connectedDestinationsCount,
  });

  factory LiveKitTokenModel.fromJson(Map<String, dynamic> json) {
    return LiveKitTokenModel(
      id: json['id'] ?? 0,
      accountId: json['account_id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      layoutType: json['layout_type'] ?? "",
      startedAt: json['started_at'] ?? "",
      endedAt: json['ended_at'] ?? "",
      deletedAt: json['deleted_at'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      isActive: json['is_active'] ?? false,
      durationSeconds: json['duration_seconds'] ?? "",
      canStart: json['can_start'] ?? "",
      canEnd: json['can_end'] ?? "",
      canArchive: json['can_archive'] ?? "",
      connectedDestinationsCount:
      json['connected_destinations_count'] ?? "",
    );
  }
}