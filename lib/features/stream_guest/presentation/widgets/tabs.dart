import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/banners_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/stream_guest/presentation/views/tabs/comment_tab.dart';

import 'package:streamore_app/features/tabs/banners/banners_contant.dart';
import 'package:streamore_app/features/tabs/banners/banners_tab.dart';
import 'package:streamore_app/features/tabs/brand/brand_tab.dart';
import 'package:streamore_app/features/tabs/chat/presentaion/views/chat_tab.dart';
import 'package:streamore_app/features/tabs/comment/comments_tab.dart';
import 'package:streamore_app/features/tabs/banners/tickers_contant.dart';
import 'package:streamore_app/features/tabs/people/people_tab.dart';

class TabsSection extends StatelessWidget {
  final TabController tabController;
  final double profileImageWidth;
  final bool isSmall;

  const TabsSection({
    super.key,
    required this.tabController,
    required this.profileImageWidth,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myprovider = Provider.of<BannersProvider>(context);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.015),
        child: Container(
          width: profileImageWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DefaultTabController(
            length: 5,
            child: Column(
              children: [
                TabBar(
                  controller: tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  labelStyle: GoogleFonts.inter(
                    fontSize: isSmall ? 10 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.inter(
                    fontSize: isSmall ? 10 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [

                    Tab(text: "comments".tr()),
                    Tab(text: "chat".tr()),

                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [

                     CommentTab(),
                      ChatTab(),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
