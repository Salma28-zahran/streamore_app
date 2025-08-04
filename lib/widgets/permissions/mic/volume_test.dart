import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VolumeTest extends StatefulWidget {
  const VolumeTest({super.key});

  @override
  State<VolumeTest> createState() => _VolumeTestState();
}

class _VolumeTestState extends State<VolumeTest> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  int currentLevel = 0;
  StreamSubscription? _recorderSubscription;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    requestMicPermission();
  }

  Future<void> requestMicPermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print("❌ Microphone permission not granted");
    } else {
      print("✅ Microphone permission granted");
    }
  }

  Future<void> startTest() async {
    if (isRecording) return;

    try {
      await _recorder.openRecorder();

      await _recorder.startRecorder(
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 44100,
      );

      _recorder.setSubscriptionDuration(Duration(milliseconds: 200));

      _recorderSubscription = _recorder.onProgress!.listen((event) {
        double decibels = event.decibels ?? 0.0;
        print("🎚️ Decibels: $decibels");

        setState(() {
          currentLevel = (decibels / 3).clamp(0, 15).toInt();
        });
      });

      setState(() => isRecording = true);
    } catch (e) {
      print("❌ Error in startTest: $e");
    }
  }

  Future<void> stopTest() async {
    if (!isRecording) return;

    try {
      await _recorder.stopRecorder();
      await _recorderSubscription?.cancel();

      setState(() {
        currentLevel = 0;
        isRecording = false;
      });
    } catch (e) {
      print("❌ Error in stopTest: $e");
    }
  }

  Color getColor(int index) {
    if (index < currentLevel) {
      if (index < 5) return Colors.green;
      if (index < 10) return Colors.yellow;
      if (index < 13) return Colors.orange;
      return Colors.red;
    }
    return Colors.grey.shade300;
  }

  @override
  void dispose() {
    _recorderSubscription?.cancel();
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: isRecording ? stopTest : startTest,
              icon: Icon(isRecording ? Icons.mic : Icons.mic),
              label: Text(isRecording ? "off".tr() : "test".tr()),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
            ),),
             SizedBox(width: 10),
            Row(
              children: List.generate(16, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  width: 10,
                  height: 40,
                  decoration: BoxDecoration(
                    color: getColor(index),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
