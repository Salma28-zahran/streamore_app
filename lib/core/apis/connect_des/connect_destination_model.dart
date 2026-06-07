class ConnectDestinationModel {
  final int? accountId;
  final String name;
  final String platformType;
  final String rtmpKey;
  final String streamUrl;

  ConnectDestinationModel({
    this.accountId,
    required this.name,
    required this.platformType,
    required this.rtmpKey,
    required this.streamUrl,
  });

  factory ConnectDestinationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ConnectDestinationModel(
      accountId: json['account_id'],
      name: json['name'] ?? '',
      platformType:
      json['platform_type'] ?? '',
      rtmpKey: json['rtmp_key'] ?? '',
      streamUrl: json['stream_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "account_id": accountId,
      "name": name,
      "platform_type": platformType,
      "rtmp_key": rtmpKey,
      "stream_url": streamUrl,
    };
  }
}