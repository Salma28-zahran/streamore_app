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

  final int durationSeconds;
  final bool canStart;
  final bool canEnd;
  final bool canArchive;
  final int connectedDestinationsCount;

  // ============================================================
  // LIVEKIT HOST DATA
  // ============================================================

  final String livekitToken;
  final String livekitUrl;
  final String roomName;

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
    required this.livekitToken,
    required this.livekitUrl,
    required this.roomName,
  });

  factory HostTokenModel.fromJson(
      Map<String, dynamic> json,
      ) {
    // ============================================================
    // بعض الـ APIs بترجع:
    //
    // {
    //   "livekit_token": "...",
    //   "livekit_url": "...",
    //   "room_name": "..."
    // }
    //
    // وبعضها:
    //
    // {
    //   "data": {
    //     "livekit_token": "...",
    //     "livekit_url": "...",
    //     "room_name": "..."
    //   }
    // }
    //
    // وبعضها:
    //
    // {
    //   "host_token": {
    //     "livekit_token": "...",
    //     "livekit_url": "...",
    //     "room_name": "..."
    //   }
    // }
    // ============================================================

    final Map<String, dynamic> rootData =
    _extractRootData(json);

    final Map<String, dynamic> liveKitData =
    _extractLiveKitData(
      originalJson: json,
      rootData: rootData,
    );

    return HostTokenModel(
      // ============================================================
      // STREAM DATA
      // ============================================================

      id: _toInt(
        rootData['id'] ?? json['id'],
      ),

      accountId: _toInt(
        rootData['account_id'] ??
            json['account_id'],
      ),

      name: (
          rootData['name'] ??
              json['name'] ??
              ''
      ).toString(),

      description: (
          rootData['description'] ??
              json['description'] ??
              ''
      ).toString(),

      status: (
          rootData['status'] ??
              json['status'] ??
              ''
      ).toString(),

      layoutType: (
          rootData['layout_type'] ??
              json['layout_type'] ??
              ''
      ).toString(),

      startedAt:
      rootData['started_at']?.toString() ??
          json['started_at']?.toString(),

      endedAt:
      rootData['ended_at']?.toString() ??
          json['ended_at']?.toString(),

      deletedAt:
      rootData['deleted_at']?.toString() ??
          json['deleted_at']?.toString(),

      createdAt: (
          rootData['created_at'] ??
              json['created_at'] ??
              ''
      ).toString(),

      updatedAt: (
          rootData['updated_at'] ??
              json['updated_at'] ??
              ''
      ).toString(),

      isActive: _toBool(
        rootData['is_active'] ??
            json['is_active'],
      ),

      durationSeconds: _toInt(
        rootData['duration_seconds'] ??
            json['duration_seconds'],
      ),

      canStart: _toBool(
        rootData['can_start'] ??
            json['can_start'],
      ),

      canEnd: _toBool(
        rootData['can_end'] ??
            json['can_end'],
      ),

      canArchive: _toBool(
        rootData['can_archive'] ??
            json['can_archive'],
      ),

      connectedDestinationsCount: _toInt(
        rootData[
        'connected_destinations_count'
        ] ??
            json[
            'connected_destinations_count'
            ],
      ),

      // ============================================================
      // LIVEKIT HOST DATA
      // ============================================================

      livekitToken: (
          liveKitData['livekit_token'] ??
              liveKitData['livekitToken'] ??
              liveKitData['liveKitToken'] ??
              ''
      ).toString(),

      livekitUrl: (
          liveKitData['livekit_url'] ??
              liveKitData['livekitUrl'] ??
              liveKitData['liveKitUrl'] ??
              ''
      ).toString(),

      roomName: (
          liveKitData['room_name'] ??
              liveKitData['roomName'] ??
              ''
      ).toString(),
    );
  }

  // ==============================================================
  // EXTRACT ROOT DATA
  // ==============================================================

  static Map<String, dynamic> _extractRootData(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return json;
  }

  // ==============================================================
  // EXTRACT LIVEKIT DATA
  // ==============================================================

  static Map<String, dynamic> _extractLiveKitData({
    required Map<String, dynamic> originalJson,
    required Map<String, dynamic> rootData,
  }) {
    // ------------------------------------------------------------
    // 1. host_token داخل root data
    // ------------------------------------------------------------

    final rootHostToken =
        rootData['host_token'] ??
            rootData['hostToken'];

    if (rootHostToken is Map<String, dynamic>) {
      return rootHostToken;
    }

    if (rootHostToken is Map) {
      return Map<String, dynamic>.from(
        rootHostToken,
      );
    }

    // ------------------------------------------------------------
    // 2. host_token داخل original response
    // ------------------------------------------------------------

    final originalHostToken =
        originalJson['host_token'] ??
            originalJson['hostToken'];

    if (originalHostToken
    is Map<String, dynamic>) {
      return originalHostToken;
    }

    if (originalHostToken is Map) {
      return Map<String, dynamic>.from(
        originalHostToken,
      );
    }

    // ------------------------------------------------------------
    // 3. لو livekit data موجودة مباشرة في data
    // ------------------------------------------------------------

    if (_containsLiveKitData(rootData)) {
      return rootData;
    }

    // ------------------------------------------------------------
    // 4. لو موجودة مباشرة في response
    // ------------------------------------------------------------

    if (_containsLiveKitData(originalJson)) {
      return originalJson;
    }

    return {};
  }

  // ==============================================================
  // CONTAINS LIVEKIT DATA
  // ==============================================================

  static bool _containsLiveKitData(
      Map<String, dynamic> json,
      ) {
    return json.containsKey('livekit_token') ||
        json.containsKey('livekitToken') ||
        json.containsKey('liveKitToken') ||
        json.containsKey('livekit_url') ||
        json.containsKey('livekitUrl') ||
        json.containsKey('liveKitUrl');
  }

  // ==============================================================
  // TO INT
  // ==============================================================

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  // ==============================================================
  // TO BOOL
  // ==============================================================

  static bool _toBool(dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final stringValue =
    value.toString().trim().toLowerCase();

    return stringValue == 'true' ||
        stringValue == '1' ||
        stringValue == 'yes';
  }

  // ==============================================================
  // TO JSON
  // ==============================================================

  Map<String, dynamic> toJson() {
    return {
      "account_id": accountId,
      "name": name,
      "description": description,
      "layout_type": layoutType,
    };
  }
}