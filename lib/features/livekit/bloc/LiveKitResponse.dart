class LiveKitResponse {
  final String livekitUrl;
  final String livekitToken;
  final String roomName;

  LiveKitResponse({
    required this.livekitUrl,
    required this.livekitToken,
    required this.roomName,
  });

  factory LiveKitResponse.fromJson(Map<String, dynamic> json) {
    return LiveKitResponse(
      livekitUrl: json['livekit_url']?.toString() ?? '',
      livekitToken: json['livekit_token']?.toString() ?? '',
      roomName: json['room_name']?.toString() ?? '',
    );
  }
}