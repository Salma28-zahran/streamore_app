import 'package:flutter/material.dart';

class RecordLiveButtons extends StatelessWidget {
  final VoidCallback onRecordTap;
  final VoidCallback onLiveTap;

  const RecordLiveButtons({
    super.key,
    required this.onRecordTap,
    required this.onLiveTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: screenHeight * 0.012,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Record Button
          GestureDetector(
            onTap: onRecordTap,
            child: Container(
              width: screenWidth * 0.10,
              height: screenHeight * 0.04,
              decoration: BoxDecoration(
                color: const Color(0xFFD9DEE7),
                borderRadius: BorderRadius.circular(
                  screenWidth * 0.035,
                ),
              ),
              child: Center(
                child: Container(
                  width: screenWidth * 0.038,
                  height: screenWidth * 0.038,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFC9C9),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.028,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: screenWidth * 0.02),

          /// Live Button
          GestureDetector(
            onTap: onLiveTap,
            child: Container(
              width: screenWidth * 0.125,
              height: screenHeight * 0.038,
              decoration: BoxDecoration(
                color: const Color(0xFFD9DEE7),
                borderRadius: BorderRadius.circular(
                  screenWidth * 0.035,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.videocam_outlined,
                  size: screenWidth * 0.055,
                  color: const Color(0xFF6B6B76),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}