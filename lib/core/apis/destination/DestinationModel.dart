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

  factory DestinationModel.fromJson(
      Map<String, dynamic> json) {

    final data = json['data'] ?? json;

    return DestinationModel(
      id: data['id'],
      name: data['name'] ?? '',
      platformType:
      data['platform_type'] ?? '',
      rtmpUrl:
      data['rtmp_url'] ?? '',
      rtmpKey:
      data['rtmp_key'] ?? '',
      streamUrl:
      data['stream_url'] ?? '',
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