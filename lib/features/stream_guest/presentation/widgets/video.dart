import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/banners_provider.dart';
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/core/provider/tickers_provider.dart';
import 'package:streamore_app/features/tabs/brand/brand_utils/font_utils.dart';

class VideoWidget extends StatefulWidget {
  final double profileImageWidth;
  final double profileImageHeight;
  final bool isZoomVisible;
  final VoidCallback _onProfileImageClick;
  final VoidCallback _onZoomIconClick;

  const VideoWidget({
    super.key,
    required this.profileImageWidth,
    required this.profileImageHeight,
    required this.isZoomVisible,
    required VoidCallback onProfileImageClick,
    required VoidCallback onZoomIconClick,
  })  : _onProfileImageClick = onProfileImageClick,
        _onZoomIconClick = onZoomIconClick;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    final myProvider = context.watch<MyProvider>();
    final displayName = myProvider.guestName ?? "No User Found"; // ✅
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
                        color: Colors.grey.withValues(alpha: 0.6),
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
                          final folderTickers = tickersProvider.currentTicker?.tickers ?? [];
                          final tickerText = folderTickers[index];
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
                  } else if (bannersProvider.shownBanners.isNotEmpty) {
                    return Positioned(
                      top: widget.profileImageHeight - 35,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: bannersProvider.shownBanners.map((index) {
                          final folderBanners = bannersProvider.currentFolder?.banners ?? [];
                          final bannerText = folderBanners[index];
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
                                    style: getFontStyle(context, myProvider.selectedFont, fontSize: 12, color: Colors.white),
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
                                          style: getFontStyle(context, myProvider.selectedFont, fontSize: 12, color: Colors.black87),
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
                                    style: getFontStyle(context, myProvider.selectedFont, fontSize: 12, color: Colors.white),
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
                      child: Consumer<CommentProvider>(
                        builder: (context, commentProvider, _) {
                          if (commentProvider.shownCommentIndex != null) {
                            return _buildCommentOverlay(context, myProvider, displayName); // ✅
                          } else {
                            return _buildThemeOverlay(context, myProvider, displayName); // ✅
                          }
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOverlay(BuildContext context, MyProvider provider, String displayName) { // ✅
    final theme = provider.selectedTheme;
    final color = provider.primaryColor;
    final font = provider.selectedFont;

    return Consumer<CommentProvider>(
      builder: (context, commentProvider, _) {
        final shownIndex = commentProvider.shownCommentIndex;
        final textToShow = shownIndex != null
            ? commentProvider.comments[shownIndex]
            : displayName; // ✅

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
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(textToShow, style: getFontStyle(context, font, fontSize: 12, color: Colors.white)),
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
                      constraints: const BoxConstraints(minWidth: 50),
                      height: 23,
                      color: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Text(textToShow, style: getFontStyle(context, font, fontSize: 12, color: Colors.black87)),
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
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 4),
                  child: Text(textToShow, style: getFontStyle(context, font, fontSize: 12, color: Colors.white)),
                ),
              ),
            );
        }
      },
    );
  }

  Widget _buildCommentOverlay(BuildContext context, MyProvider provider, String displayName) { // ✅
    final theme = provider.selectedTheme;
    final color = provider.primaryColor;
    final font = provider.selectedFont;

    return Consumer<CommentProvider>(
      builder: (context, commentProvider, _) {
        final shownIndex = commentProvider.shownCommentIndex;
        final textToShow = shownIndex != null
            ? commentProvider.comments[shownIndex]
            : displayName; // ✅

        if (shownIndex == null) return const SizedBox();

        switch (theme) {
          case 'bubble':
            return Padding(
              padding: const EdgeInsets.all(11),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.004,
                    ),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(31)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xFFBDBDBD),
                          child: Icon(Icons.person, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          displayName, // ✅
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.035,
                        vertical: MediaQuery.of(context).size.height * 0.006,
                      ),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
                      child: Text(
                        textToShow,
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            );

          case 'minimal':
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.013),
              child: Center(
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(width: MediaQuery.of(context).size.width * 0.035, color: color),
                      Container(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.35,
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.04,
                              backgroundColor: const Color(0xFFBDBDBD),
                              child: const Icon(Icons.person, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    displayName, // ✅
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF000000)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    textToShow,
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF000000)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

          case 'news':
          default:
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9425,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.003,
                  ),
                  decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(0xFFBDBDBD),
                        child: Icon(Icons.person, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        displayName, // ✅
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF000000)),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9425,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.003,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(3), bottomRight: Radius.circular(3)),
                    color: color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
                    child: Text(
                      textToShow,
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}