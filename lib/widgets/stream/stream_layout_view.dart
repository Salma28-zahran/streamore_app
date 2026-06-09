import 'package:flutter/material.dart';

class StreamLayoutView extends StatelessWidget {
  final String layout;
  final double width;
  final double height;
  final VoidCallback onTap;

  const StreamLayoutView({
    super.key,
    required this.layout,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case 'cropped':
        return _buildCropped();

      case 'spotlight':
        return _buildSpotlight();

      case 'screen':
        return _buildScreen();

      case 'pip':
        return _buildPip();

      case 'news':
        return _buildNews();

      case 'cinema':
        return _buildCinema();

      case 'default':
      default:
        return _buildDefault();
    }
  }

  Widget _frame({required Widget child}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xff4B4B55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _image() {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          "assets/images/profile5.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2C2C33),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildDefault() {
    return _frame(
      child: SizedBox.expand(
        child: _image(),
      ),
    );
  }

  Widget _buildCropped() {
    return _frame(
      child: Row(
        children: [
          Expanded(child: _image()),
          const SizedBox(width: 4),
          Expanded(child: _image()),
        ],
      ),
    );
  }

  Widget _buildScreen() {
    return _frame(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(child: _image()),
                const SizedBox(height: 4),
                Expanded(child: _image()),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: _placeholder(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotlight() {
    return _frame(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _image(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _image()),
                const SizedBox(height: 4),
                Expanded(child: _image()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNews() {
    return _frame(
      child: Row(
        children: [
          Expanded(
            child: _image(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _placeholder(),
          ),
        ],
      ),
    );
  }

  Widget _buildPip() {
    return _frame(
      child: Stack(
        children: [
          Positioned.fill(
            child: _image(),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: SizedBox(
              width: width * 0.22,
              height: height * 0.28,
              child: _image(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinema() {
    return _frame(
      child: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _placeholder(),
          ),
        ),
      ),
    );
  }
}