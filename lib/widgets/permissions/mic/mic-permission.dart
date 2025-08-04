import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart'; 

Future<void> requestMicPermission(BuildContext context, Function setMicState) async {
  final status = await Permission.microphone.request();

  if (status.isGranted) {
    setMicState();
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
      content: Text('grant_microphone_access'.tr()), 
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ok'.tr()), 
        ),
      ],
    ),
  );
}
