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

    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final bool hasNotification;

    return Scaffold(
      //backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Theme
              .of(context)
              .appBarTheme
              .backgroundColor,
          title: Image.asset("assets/images/app_name.png"),
          leading: GestureDetector(
            onTap: () {
              context.read<MyProvider>().changeTheme();
            },
            child: Icon(
              isDark ? Icons.wb_sunny : Icons.dark_mode,
              size: 25,
              color:
              isDark ? Colors.amber : Theme
                  .of(context)
                  .primaryColor,
            ),
          ),

          bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
      child: Divider(
        color: Theme
            .of(context)
            .dividerColor,
        thickness: 0.5,
        height: 1,
      ),
    ),
    ),
    body: SafeArea(
    child: Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 15),
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
    const SizedBox(width: 12),
    ],
    ),
    const SizedBox(height: 20),
    Text(
    "Streams and Recordings:",
    style: TextStyle(
    color: isDark ? Colors.white : Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    ),
    ),
    const SizedBox(height: 15),
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
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    final date = DateFormat('dd MMM');
    final time = DateFormat('HH:mm');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.25)
              : Colors.black.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// 🔵 Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            child: Icon(
              Icons.circle,
              size: 10,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(width: 12),

          /// 📝 Title + Type
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
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),

          /// 📅 Created (سطرين)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date.format(created),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
                Text(
                  time.format(created),
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          /// ⏳ Scheduled (سطرين)

          const SizedBox(width: 8),

          /// 🔘 Button
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(0, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(
                color: Color(0xff1865E8),
                width: 1,
              ),
              foregroundColor: isDark ? Colors.white : Colors.black,
              textStyle: const TextStyle(fontSize: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
    VoidCallback? onTap, // 👈 ضيفي دي
  }) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff1865E8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
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
