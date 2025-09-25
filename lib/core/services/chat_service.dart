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
  static Future<bool> sendMessage({
    required String token,
    required int chatId,
    required String content,
  }) async {
    final url = Uri.parse("${baseUrl}${chatId}/send/");
    try {
      final resp = await http.post(
        url,
        headers: {
          'Authorization': 'Token $token',
        },
        body: jsonEncode({'content': content}),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        print("📤 Message sent: $content");
        return true;
      } else {
        print("❌ Failed to send message: ${resp.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception sending message: $e");
      return false;
    }




  }
  /// 6. Get Chat Messages
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






  /// 3. Upload Media Message
  static Future<Map<String, dynamic>?> uploadMedia({
    required String token,
    required int chatId,
    required File file,
  }) async {
    final url = Uri.parse("${baseUrl}media_message/$chatId/");
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
    final url = Uri.parse("${baseUrl}chat/$chatId/");
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
      print("❌ exitChat error: ${response.body}");
      return false;
    }
  }

  /// 5. Participants Status
  static Future<Map<String, dynamic>?> getParticipantsStatus({
    required String token,
    required int chatId,
  }) async {
    final url = Uri.parse("${baseUrl}chat/$chatId/");
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
      print("❌ getParticipantsStatus error: ${response.body}");
      return null;
    }
  }
}
