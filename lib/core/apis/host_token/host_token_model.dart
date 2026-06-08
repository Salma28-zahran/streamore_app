class HostTokenModel {
  final int id;
  final int accountId;
  final String name;
  final String description;
  final String status;
  final String layoutType;
  final String? startedAt;
  final String? endedAt;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final bool isActive;
  final String durationSeconds;
  final String canStart;
  final String canEnd;
  final String canArchive;
  final String connectedDestinationsCount;

  HostTokenModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.description,
    required this.status,
    required this.layoutType,
    this.startedAt,
    this.endedAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.durationSeconds,
    required this.canStart,
    required this.canEnd,
    required this.canArchive,
    required this.connectedDestinationsCount,
  });

  factory HostTokenModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return HostTokenModel(
      id: json['id'] ?? 0,
      accountId:
      json['account_id'] ?? 0,
      name: json['name'] ?? '',
      description:
      json['description'] ?? '',
      status:
      json['status'] ?? '',
      layoutType:
      json['layout_type'] ?? '',
      startedAt:
      json['started_at'],
      endedAt:
      json['ended_at'],
      deletedAt:
      json['deleted_at'],
      createdAt:
      json['created_at'] ?? '',
      updatedAt:
      json['updated_at'] ?? '',
      isActive:
      json['is_active'] ?? false,
      durationSeconds:
      json['duration_seconds']
          .toString(),
      canStart:
      json['can_start']
          .toString(),
      canEnd:
      json['can_end']
          .toString(),
      canArchive:
      json['can_archive']
          .toString(),
      connectedDestinationsCount:
      json[
      'connected_destinations_count']
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "account_id":
      accountId,
      "name": name,
      "description":
      description,
      "layout_type":
      layoutType,
    };
  }
}