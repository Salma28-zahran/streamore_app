import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/banners_provider.dart';
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/tabs/brand/brand_utils/font_utils.dart';

import '../../core/helpers/storage_helper.dart';
import '../../core/provider/tickers_provider.dart';

class ProfileImageWithBanners extends StatefulWidget {
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
  State<ProfileImageWithBanners> createState() => _ProfileImageWithBannersState();
}

class _ProfileImageWithBannersState extends State<ProfileImageWithBanners> {
  String? userName;
  @override
  void initState() {
    super.initState();
    loadUserName();
  }
  Future<void> loadUserName() async {
    final email = await StorageHelper.getEmail();
    if (email != null && email.contains('@')) {
      setState(() {
        userName = email.split('@')[0];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final bannersProvider = Provider.of<BannersProvider>(context);
    final tickersProvider = Provider.of<TickersProvider>(context);
    final isTickerMode = tickersProvider.tFolderClicked;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: widget._onProfileImageClick,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    "assets/images/profile4.png",
                    width: widget.profileImageWidth,
                    height: widget.profileImageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              if (widget.isZoomVisible)
                Positioned(
                  top: widget.profileImageHeight / 2 - 27,
                  left: widget.profileImageWidth / 2 - 27,
                  child: GestureDetector(
                    onTap: widget._onZoomIconClick,
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
                  if (tickersProvider.shownTickers.isNotEmpty) {
                    return Positioned(
                      bottom: isTickerMode ? 0 : null,
                      top: isTickerMode ? null : widget.profileImageHeight - 35,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: tickersProvider.shownTickers.map((index) {
                          final tickerText = tickersProvider.tickers[index];
                          return SizedBox(
                            height: 25,
                            child: Container(
                              height: 25,
                              width: double.infinity,
                              color: myProvider.primaryColor,
                              child: Marquee(
                                text: tickerText,
                                style: getFontStyle(
                                  context,
                                  myProvider.selectedFont,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                blankSpace: 50.0,
                                velocity: 40.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                startPadding: 10.0,
                                accelerationDuration: const Duration(seconds: 1),
                                decelerationDuration: const Duration(milliseconds: 500),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }

                  // 2) حالة البانرز: تعرض عناصر bannersProvider.shownBanners فقط
                  else if (!isTickerMode && bannersProvider.shownBanners.isNotEmpty) {
                    return Positioned(
                      top: widget.profileImageHeight - 35,
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
                  }

                  else {
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
            : (userName ?? "No User Found");

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
                child: Padding(
                  padding: const EdgeInsets.only(left: 4,right: 4),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4,right: 4),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 5,right: 4),
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
              ),
            );
        }
      },
    );
  }
}