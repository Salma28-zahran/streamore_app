class DisconnectDestinationModel {
  final int id;
  final int accountId;
  final String name;
  final String platformType;
  final String rtmpKey;
  final String rtmpUrl;
  final String streamUrl;
  final String status;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final String canConnect;

  DisconnectDestinationModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.platformType,
    required this.rtmpKey,
    required this.rtmpUrl,
    required this.streamUrl,
    required this.status,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.canConnect,
  });

  factory DisconnectDestinationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DisconnectDestinationModel(
      id: json['id'] ?? 0,
      accountId:
      json['account_id'] ?? 0,
      name: json['name'] ?? '',
      platformType:
      json['platform_type'] ?? '',
      rtmpKey:
      json['rtmp_key'] ?? '',
      rtmpUrl:
      json['rtmp_url'] ?? '',
      streamUrl:
      json['stream_url'] ?? '',
      status:
      json['status'] ?? '',
      deletedAt:
      json['deleted_at'],
      createdAt:
      json['created_at'] ?? '',
      updatedAt:
      json['updated_at'] ?? '',
      canConnect:
      json['can_connect']
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "account_id":
      accountId,
      "name": name,
      "platform_type":
      platformType,
      "rtmp_key":
      rtmpKey,
      "stream_url":
      streamUrl,
    };
  }
}