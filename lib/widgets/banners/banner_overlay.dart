import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/my_provider.dart';

class BannerOverlay extends StatelessWidget {
  const BannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        if (myProvider.shownBanners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: myProvider.shownBanners.map((index) {
            final bannerText = myProvider.banners[index];
            return Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                bannerText,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}