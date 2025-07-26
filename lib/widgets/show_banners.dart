import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/my_provider.dart';
import 'package:streamore_app/widgets/brand_widgets/brand_utils/font_utils.dart';

class ProfileImageWithBanners extends StatelessWidget {
  final double profileImageWidth;
  final double profileImageHeight;
  final bool isZoomVisible;
  final VoidCallback _onProfileImageClick;
  final VoidCallback _onZoomIconClick;

  const ProfileImageWithBanners({
    super.key,
    required this.profileImageWidth,
    required this.profileImageHeight,
    required this.isZoomVisible,
    required VoidCallback onProfileImageClick,
    required VoidCallback onZoomIconClick,
  })  : _onProfileImageClick = onProfileImageClick,
        _onZoomIconClick = onZoomIconClick;

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Profile Image
              GestureDetector(
                onTap: _onProfileImageClick,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    "assets/images/profile4.png",
                    width: profileImageWidth,
                    height: profileImageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Zoom Icon
              if (isZoomVisible)
                Positioned(
                  top: profileImageHeight / 2 - 27,
                  left: profileImageWidth / 2 - 27,
                  child: GestureDetector(
                    onTap: _onZoomIconClick,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/zoom.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),

              // Banner or UserName
              Consumer<MyProvider>(
                builder: (context, myProvider, child) {
                  if (myProvider.shownBanners.isNotEmpty) {
                    return Positioned(
                      top: profileImageHeight - 35,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: myProvider.shownBanners.map((index) {
                          final bannerText = myProvider.banners[index];
                          switch (myProvider.selectedTheme) {
                            case 'bubble':
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: myProvider.primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    bannerText,
                                    style: getFontStyle(
                                      context,
                                      myProvider.selectedFont,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            case 'minimal':
                              return Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(width: 12, height: 24, color: myProvider.primaryColor),
                                    Container(
                                      width: 76,
                                      height: 23,
                                      color: Colors.white,
                                      child: Center(
                                        child: Text(
                                          bannerText,
                                          style: getFontStyle(
                                            context,
                                            myProvider.selectedFont,
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            case 'news':
                            default:
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: myProvider.primaryColor,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Text(
                                    bannerText,
                                    style: getFontStyle(
                                      context,
                                      myProvider.selectedFont,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                          }
                        }).toList(),
                      ),
                    );
                  } else {
                    return Positioned(
                      bottom: 0,
                      left: 0,
                      child: _buildThemeOverlay(context, myProvider),
                    );
                  }
                },
              ),

              // Comments
              Positioned(
                bottom: 100,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: myProvider.comments.map((comment) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.person, size: 24, color: Colors.white54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "UserName",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 6,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOverlay(BuildContext context, MyProvider provider) {
  final theme = provider.selectedTheme;
  final color = provider.primaryColor;
  final font = provider.selectedFont;

  switch (theme) {
    case 'bubble':
      return Padding(
        padding: EdgeInsets.all(11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            "user_name".tr(),
            style: getFontStyle(
              context,
              font,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      );

    case 'minimal':
      return Padding(
        padding: EdgeInsets.only(bottom: 11),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 24, color: color),
              Container(
                width: 76,
                height: 23,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "user_name".tr(),
                    style: getFontStyle(
                      context,
                      font,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

    case 'news':
    default:
      return Padding(
        padding: EdgeInsets.all(11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Text(
            "user_name".tr(),
            style: getFontStyle(
              context,
              font,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      );
  }
}
}