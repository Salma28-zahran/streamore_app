import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? sender;
  RTCPeerConnection? receiver;

  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  /// ========================
  /// INIT
  /// ========================
  Future<void> init() async {
    await remoteRenderer.initialize();

    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    sender = await createPeerConnection(config);
    receiver = await createPeerConnection(config);

    /// 🔴 استقبال الفيديو
    receiver!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    /// 🔴 ICE candidate (ربط الطرفين)
    sender!.onIceCandidate = (candidate) {
      receiver!.addCandidate(candidate);
    };

    receiver!.onIceCandidate = (candidate) {
      sender!.addCandidate(candidate);
    };
  }

  /// ========================
  /// START SCREEN SHARE
  /// ========================
  Future<void> startScreenShare() async {
    try {
      final stream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': false,
      });

      /// إضافة التراكات للـ sender
      stream.getTracks().forEach((track) {
        sender!.addTrack(track, stream);
      });

      /// Create Offer
      final offer = await sender!.createOffer();
      await sender!.setLocalDescription(offer);

      /// وصلها للـ receiver
      await receiver!.setRemoteDescription(offer);

      /// Create Answer
      final answer = await receiver!.createAnswer();
      await receiver!.setLocalDescription(answer);

      /// رجّعها للـ sender
      await sender!.setRemoteDescription(answer);
    } catch (e) {
      print("Error in screen share: $e");
    }
  }

  /// ========================
  /// DISPOSE
  /// ========================
  Future<void> dispose() async {
    await sender?.close();
    await receiver?.close();
    remoteRenderer.dispose();
  }
}