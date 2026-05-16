import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:streamore_app/core/services/WebRTCService.dart';

class ShareScreenView extends StatefulWidget {
  final WebRTCService service;

  const ShareScreenView({
    super.key,
    required this.service,
  });

  @override
  State<ShareScreenView> createState() => _ShareScreenViewState();
}

class _ShareScreenViewState extends State<ShareScreenView> {

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    // تأكيد إن الـ renderer جاهز
    await widget.service.remoteRenderer.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    // تنظيف الموارد
    widget.service.sender?.close();
    widget.service.receiver?.close();
    widget.service.remoteRenderer.srcObject = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen Sharing"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: RTCVideoView(
                widget.service.remoteRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
              ),
            ),
          ),

          /// 🔴 Stop Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                widget.service.sender?.close();
                widget.service.receiver?.close();
                widget.service.remoteRenderer.srcObject = null;

                Navigator.pop(context);
              },
              child: const Text("Stop Sharing"),
            ),
          )
        ],
      ),
    );
  }
}