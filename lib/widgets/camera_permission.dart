import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestCameraPermission(BuildContext context, VoidCallback onGranted) async {
  var status = await Permission.camera.status;

  if (status.isGranted) {
    onGranted(); // Call your function if granted
  } else if (status.isDenied) {
    _showPermissionDialog(context, onGranted);
  } else if (status.isPermanentlyDenied) {
    _showPermanentDenialDialog(context);
  }
}

Future<void> _requestPermission(BuildContext context, VoidCallback onGranted) async {
  var status = await Permission.camera.request();
  if (status.isGranted) {
    onGranted();
  }
}

void _showPermissionDialog(BuildContext context, VoidCallback onGranted) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Camera Permission'),
      content: Text('This app needs camera access. Please grant permission to continue.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _requestPermission(context, onGranted);
          },
          child: Text('Grant'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Deny'),
        ),
      ],
    ),
  );
}

void _showPermanentDenialDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Permission Denied'),
      content: Text('You have permanently denied camera access. Enable it from settings.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            openAppSettings();
          },
          child: Text('Open Settings'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    ),
  );
}
