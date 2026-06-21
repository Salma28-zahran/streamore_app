import 'package:flutter/material.dart';

class KeyboardSafePage extends StatelessWidget {
  final Widget child;

  const KeyboardSafePage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        ),
      ),
    );
  }
}