import 'dart:async';
import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebStudioBridge {
  WebStudioBridge._();

  static InAppWebViewController? _controller;

  static Completer<void> _pageReadyCompleter =
  Completer<void>();

  static Completer<void>? _canvasReadyCompleter;

  static void attachController(
      InAppWebViewController controller,
      ) {
    _controller = controller;
  }

  static void markPageReady() {
    if (!_pageReadyCompleter.isCompleted) {
      _pageReadyCompleter.complete();
    }
  }

  static void markCanvasReady() {
    final completer = _canvasReadyCompleter;

    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  static Future<void> start({
    required String liveKitUrl,
    required String liveKitToken,
    required String roomName,
    required int streamId,
    required int accountId,
  }) async {
    final controller = _controller;

    if (controller == null) {
      throw Exception(
        'Web Studio is not mounted',
      );
    }

    await _pageReadyCompleter.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw Exception(
          'Web Studio page did not load',
        );
      },
    );

    _canvasReadyCompleter = Completer<void>();

    final payload = jsonEncode({
      'livekitUrl': liveKitUrl,
      'livekitToken': liveKitToken,
      'roomName': roomName,
      'streamId': streamId,
      'accountId': accountId,
    });

    // التوكن لا يوضع داخل الرابط.
    await controller.evaluateJavascript(
      source: '''
        if (typeof window.startMobileStudio !== 'function') {
          throw new Error('startMobileStudio is not available');
        }

        window.startMobileStudio($payload);
      ''',
    );

    await _canvasReadyCompleter!.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception(
          'broadcast-canvas was not published by Web Studio',
        );
      },
    );
  }
}