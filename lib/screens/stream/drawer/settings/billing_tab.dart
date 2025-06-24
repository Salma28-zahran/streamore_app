import 'package:flutter/material.dart';

class BillingTab extends StatelessWidget {
  const BillingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350,
          height: 161,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xff5E5E66), width: 1),
          ),

        )
      ],
    );
  }
}
