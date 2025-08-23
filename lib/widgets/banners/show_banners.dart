import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/banners_provider.dart';
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/tabs/brand/brand_utils/font_utils.dart';

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
    final bannersProvider = Provider.of<BannersProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
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

              Consumer<MyProvider>(
                builder: (context, myProvider, child) {
                  if (bannersProvider.shownBanners.isNotEmpty) {
                    return Positioned(
                      top: profileImageHeight - 35,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: bannersProvider.shownBanners.map((index) {
                          final bannerText = bannersProvider.banners[index];
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

              // Done***************** C
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

    return Consumer<CommentProvider>(
      builder: (context, commentProvider, _) {
        final shownIndex = commentProvider.shownCommentIndex;
        final textToShow = shownIndex != null
            ? commentProvider.comments[shownIndex]
            : "user_name".tr();

        switch (theme) {
          case 'bubble':
            return Padding(
              padding: const EdgeInsets.all(11),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  textToShow,
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
              padding: const EdgeInsets.only(bottom: 11),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 24, color: color),
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 50,
                      ),
                      height: 23,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          textToShow,
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
              padding: const EdgeInsets.all(11),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  textToShow,
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
      },
    );
  }
}