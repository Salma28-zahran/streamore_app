import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' show read;
import 'package:streamore_app/features/stream/stream_screen.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/my_provider.dart';

class NewStream extends StatefulWidget {
  final bool hasNotification;
  static const String routeName = "/new_stream";

  const NewStream({
    super.key,
    this.hasNotification = false,
  });

  @override
  State<NewStream> createState() => _NewStreamState();
}

class _NewStreamState extends State<NewStream> {
  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final myprovider = Provider.of<MyProvider>(context);
    final size = MediaQuery.of(context).size;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasNotification;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Image.asset(
          "assets/images/app_name2.png",
          height: size.height * 0.05,
          width: size.width * 0.46,
        ),
        leading: GestureDetector(
          onTap: () {
            context.read<MyProvider>().changeTheme();
          },
          child: Icon(
            isDark ? Icons.wb_sunny : Icons.dark_mode,
            size: size.width * 0.064,
            color: isDark ? Colors.amber : Theme.of(context).primaryColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.001),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: size.height * 0.0006,
            height: size.height * 0.001,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.038),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.018),
              Row(
                children: [
                  Expanded(
                    child: buildCard(
                      context: context,
                      icon: Icons.videocam,
                      title: "New Stream",
                      subtitle: "Go live on 10 destinations",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StreamScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                ],
              ),
              SizedBox(height: size.height * 0.024),
              Text(
                "Streams and Recordings:",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: size.width * 0.061,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: size.height * 0.018),
              Column(
                children: [
                  buildStreamItem(
                    context: context,
                    title: "G",
                    type: "Record only",
                    created: DateTime.now(),
                    scheduled: null,
                  ),
                  buildStreamItem(
                    context: context,
                    title: "G",
                    type: "Record only",
                    created: DateTime.now(),
                    scheduled: null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStreamItem({
    required BuildContext context,
    required String title,
    required String type,
    required DateTime created,
    DateTime? scheduled,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final date = DateFormat('dd MMM');
    final time = DateFormat('HH:mm');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.036,
        vertical: size.height * 0.014,
      ),
      margin: EdgeInsets.only(
        bottom: size.height * 0.012,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(size.width * 0.036),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.25)
              : Colors.black.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(size.width * 0.015),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            child: Icon(
              Icons.circle,
              size: size.width * 0.025,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.036,
                  ),
                ),
                SizedBox(height: size.height * 0.003),
                Row(
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: size.width * 0.028,
                      ),
                    ),
                    SizedBox(width: size.width * 0.015),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: size.width * 0.028,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.008),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date.format(created),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: size.width * 0.031,
                  ),
                ),
                Text(
                  time.format(created),
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: size.width * 0.028,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.02),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StreamScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.025,
                vertical: size.height * 0.0045,
              ),
              minimumSize: Size(0, size.height * 0.034),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(
                color: Color(0xff1865E8),
                width: 1,
              ),
              foregroundColor: isDark ? Colors.white : Colors.black,
              textStyle: TextStyle(
                fontSize: size.width * 0.028,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.02),
              ),
            ),
            child: const Text(
              "Enter studio",
              style: TextStyle(color: Color(0xff1865E8)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size.width * 0.03),
      child: Container(
        padding: EdgeInsets.all(size.width * 0.041),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.025),
              decoration: BoxDecoration(
                color: const Color(0xff1865E8),
                borderRadius: BorderRadius.circular(size.width * 0.025),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: size.width * 0.06,
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.038,
                    ),
                  ),
                  SizedBox(height: size.height * 0.004),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: size.width * 0.031,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}