import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = "http://34.39.27.45:8000/api/chat/";

  /// 1. Create Chat
  static Future<Map<String, dynamic>?> createChat(
      String token, {
        required List<int> userIds,
        bool isGroup = false,
        String name = "",
      }) async {
    final url = Uri.parse("${baseUrl}create/");

    final body = jsonEncode({
      "user_ids": userIds,
      "is_group": isGroup,
      "name": name,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Token $token",
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print("❌ createChat error: ${response.statusCode} → ${response.body}");
      return null;
    }
  }



  /// 2. Send Message
  static Future<Map<String, dynamic>?> sendMessage(
      String token, {
        required int chatId,
        required String content,
      }) async {
    final url = Uri.parse("${baseUrl}$chatId/send/");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Token $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"content": content}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    print("❌ sendMessage failed: ${response.statusCode} → ${response.body}");
    return null;
  }

  /// 3. Upload Media Message
  static Future<Map<String, dynamic>?> uploadMedia({
    required String token,
    required int chatId,
    required File file,
  }) async {
    final url = Uri.parse("${baseUrl}$chatId/upload-media/");
    final request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = "Token $token";
    request.files.add(
      await http.MultipartFile.fromPath("media", file.path),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(responseBody);
    } else {
      print("❌ uploadMedia error: $responseBody");
      return null;
    }
  }

  /// 4. Exit Chat
  static Future<bool> exitChat({
    required String token,
    required int chatId,
  }) async {
    final url = Uri.parse("${baseUrl}$chatId/exit-chat/");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Exited chat: ${response.body}");
      return true;
    } else {
      print("❌ exitChat error: ${response.statusCode} → ${response.body}");
      return false;
    }
  }

  /// 5. Participants Status
  static Future<Map<String, dynamic>?> getParticipantsStatus({
    required String token,
    required int chatId,
  }) async {
    final url = Uri.parse("${baseUrl}$chatId/participants-status/");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200) {
      print("✅ Participants status: ${response.body}");
      return jsonDecode(response.body);
    } else {
      print("❌ getParticipantsStatus error: ${response.statusCode} → ${response.body}");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getChatMessages({
    required String token,
    required int chatId,
  }) async {
    final url = Uri.parse("${baseUrl}$chatId/messages/");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Token $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("❌ getChatMessages error: ${response.statusCode} → ${response.body}");
      return [];
    }
  }
}
