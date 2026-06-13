import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/background-overlay-logo_provider.dart';

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
        return _buildCropped(context);

      case 'spotlight':
        return _buildSpotlight(context);

      case 'screen':
        return _buildScreen(context);

      case 'pip':
        return _buildPip(context);

      case 'news':
        return _buildNews(context);

      case 'cinema':
        return _buildCinema(context);

      case 'default':
      default:
        return _buildDefault(context);
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

  Widget _image(BuildContext context) {
    final overlayProvider =
    context.watch<BackgroundOverlayLogoProvider>();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: overlayProvider.selectedOverlayImage != null
            ? Image.file(
          File(
            overlayProvider.selectedOverlayImage!.path,
          ),
          fit: BoxFit.cover,
        )
            : Image.asset(
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

  Widget _buildDefault(BuildContext context) {
    return _frame(
      child: SizedBox.expand(
        child: _image(context),
      ),
    );
  }

  Widget _buildCropped(BuildContext context) {
    return _frame(
      child: Row(
        children: [
          Expanded(child: _image(context)),
          const SizedBox(width: 4),
          Expanded(child: _image(context)),
        ],
      ),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return _frame(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(child: _image(context)),
                const SizedBox(height: 4),
                Expanded(child: _image(context)),
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

  Widget _buildSpotlight(BuildContext context) {
    return _frame(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _image(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _image(context)),
                const SizedBox(height: 4),
                Expanded(child: _image(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNews(BuildContext context) {
    return _frame(
      child: Row(
        children: [
          Expanded(
            child: _image(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _placeholder(),
          ),
        ],
      ),
    );
  }

  Widget _buildPip(BuildContext context) {
    return _frame(
      child: Stack(
        children: [
          Positioned.fill(
            child: _image(context),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: SizedBox(
              width: width * 0.22,
              height: height * 0.28,
              child: _image(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinema(BuildContext context) {
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