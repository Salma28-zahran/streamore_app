import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'web_studio_bridge.dart';

class MobileStudioWebView extends StatelessWidget {
  const MobileStudioWebView({
    super.key,
  });

  static const String mobileStudioUrl =
      'https://YOUR-WEB-DOMAIN.com/mobile-studio';

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(
          mobileStudioUrl,
        ),
      ),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        transparentBackground: false,
        supportZoom: false,
      ),
      onWebViewCreated: (
          InAppWebViewController controller,
          ) {
        WebStudioBridge.attachController(
          controller,
        );

        controller.addJavaScriptHandler(
          handlerName: 'canvasReady',
          callback: (arguments) {
            debugPrint(
              '✅ WEB BROADCAST CANVAS READY',
            );

            debugPrint(
              '📦 WEB DATA => $arguments',
            );

            WebStudioBridge.markCanvasReady();

            return {
              'received': true,
            };
          },
        );

        controller.addJavaScriptHandler(
          handlerName: 'studioError',
          callback: (arguments) {
            debugPrint(
              '❌ WEB STUDIO ERROR => $arguments',
            );

            return {
              'received': true,
            };
          },
        );
      },
      onLoadStop: (
          controller,
          url,
          ) async {
        debugPrint(
          '✅ WEB STUDIO PAGE LOADED => $url',
        );

        WebStudioBridge.markPageReady();
      },
      onPermissionRequest: (
          controller,
          request,
          ) async {
        return PermissionResponse(
          resources: request.resources,
          action:
          PermissionResponseAction.GRANT,
        );
      },
      onConsoleMessage: (
          controller,
          consoleMessage,
          ) {
        debugPrint(
          '🌐 WEB STUDIO => '
              '${consoleMessage.message}',
        );
      },
    );
  }
}