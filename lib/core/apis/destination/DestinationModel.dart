class DestinationModel {
  final int? id;
  final String name;
  final String platformType;
  final String rtmpUrl;
  final String rtmpKey;
  final String streamUrl;

  DestinationModel({
    this.id,
    required this.name,
    required this.platformType,
    required this.rtmpUrl,
    required this.rtmpKey,
    required this.streamUrl,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      name: json['name'] ?? '',
      platformType: json['platform_type'] ?? '',
      rtmpUrl: json['rtmp_url'] ?? '',
      rtmpKey: json['rtmp_key'] ?? '',
      streamUrl: json['stream_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "platform_type": platformType,
      "rtmp_url": rtmpUrl,
      "rtmp_key": rtmpKey,
      "stream_url": streamUrl,
    };
  }
}