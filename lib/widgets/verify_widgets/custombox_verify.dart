import 'package:flutter/material.dart';

class CustomboxVerify extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;

  const CustomboxVerify({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocus,
  });

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 39,
        height: 45,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey,
          ),
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            counterText: "",
            filled: true,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(color: Color(0xffA8A8A9), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xffA8A8A9), width: 1),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty && nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            }
          },
        ),
      );

  }
}
