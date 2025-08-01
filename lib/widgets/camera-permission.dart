import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart'; 

Future<void> requestCameraPermission(BuildContext context, Function setCamState) async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    setCamState();
  } else if (status.isDenied) {
    _showPermissionDeniedDialog(context);
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

void _showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('permission_denied'.tr()),
      content: Text('grant_camera_access'.tr()), 
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ok'.tr()), 
        ),
      ],
    ),
  );
}
