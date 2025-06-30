import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../my_provider.dart';
import 'brand_theme_buttons.dart';

Widget buildSectionHeader({
  required String title,
  required bool isVisible,
  required VoidCallback onToggle,
  required String font,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
    child: GestureDetector(
      onTap: onToggle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: getFontStyle(font, fontSize: 14, fontWeight: FontWeight.bold),
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

Widget buildLogoSection({
  required bool isVisible,
  required VoidCallback onToggle,
  required String font,
}) {
  return Column(
    children: [
      buildSectionHeader(
        title: "Logo",
        isVisible: isVisible,
        onToggle: onToggle,
        font: font,
      ),
      if (isVisible)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              _buildImageBox(image: Image.asset("assets/images/logo.png", width: 40)),
              const SizedBox(width: 10),
              _buildAddBox(),
            ],
          ),
        ),
    ],
  );
}

Widget buildOverlaySection({
  required bool isVisible,
  required VoidCallback onToggle,
  required String font,
}) {
  return Column(
    children: [
      buildSectionHeader(
        title: "Overlay",
        isVisible: isVisible,
        onToggle: onToggle,
        font: font,
      ),
      if (isVisible)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(7, (index) => _buildImageBox())..add(_buildAddBox()),
          ),
        ),
    ],
  );
}

Widget buildBackgroundSection({
  required bool isVisible,
  required VoidCallback onToggle,
  required String font,
}) {
  return Column(
    children: [
      buildSectionHeader(
        title: "Background",
        isVisible: isVisible,
        onToggle: onToggle,
        font: font,
      ),
      if (isVisible)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(7, (index) => _buildImageBox())..add(_buildAddBox()),
          ),
        ),
    ],
  );
}

Widget _buildImageBox({Image? image}) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: Colors.grey[300],
    ),
    child: image != null
        ? ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: image,
    )
        : null,
  );
}

Widget _buildAddBox() {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.grey.shade400),
      color: Colors.white,
    ),
    child: const Center(
      child: Icon(Icons.add, color: Colors.black54),
    ),
  );
}
