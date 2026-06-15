class LiveKitTokenModel {
  final int id;
  final int accountId;
  final String name;
  final String description;
  final String status;
  final String layoutType;
  final String createdAt;
  final String updatedAt;
  final bool isActive;
  final String durationSeconds;
  final String canStart;
  final String canEnd;
  final String canArchive;
  final String connectedDestinationsCount;

  /// 🔥 ADD THESE (IMPORTANT)
  final String? livekitUrl;
  final String? livekitToken;

  LiveKitTokenModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.description,
    required this.status,
    required this.layoutType,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.durationSeconds,
    required this.canStart,
    required this.canEnd,
    required this.canArchive,
    required this.connectedDestinationsCount,
    this.livekitUrl,
    this.livekitToken,
  });

  factory LiveKitTokenModel.fromJson(Map<String, dynamic> json) {
    return LiveKitTokenModel(
      id: json['id'] ?? 0,
      accountId: json['account_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      layoutType: json['layout_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isActive: json['is_active'] ?? false,
      durationSeconds: json['duration_seconds'].toString(),
      canStart: json['can_start'].toString(),
      canEnd: json['can_end'].toString(),
      canArchive: json['can_archive'].toString(),
      connectedDestinationsCount: json['connected_destinations_count'].toString(),

      /// 🔥 MAP API RESPONSE HERE
      livekitUrl: json['livekit_url'],
      livekitToken: json['livekit_token'],
    );
  }
}