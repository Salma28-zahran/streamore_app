import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/widgets/brand_widgets/brand_utils/font_utils.dart';
import '../../provider/my_provider.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isVisible;
  final VoidCallback onToggle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
      child:
      GestureDetector(
        onTap: onToggle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getFontStyle(
                context,
                myProvider.selectedFont,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              isVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
