import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:streamore_app/my_provider.dart' show MyProvider;
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/widgets/volume_test.dart';


class Audio extends StatefulWidget {
  static const routeName = "/audio";
  const Audio({super.key});

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyProvider>(context);
    bool _isOverlayEnabled = false;
    bool hasNotification = false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).primaryColorDark,
                  size: 24,
                ),
                if (hasNotification)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            height: 1,
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: myprovider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  size: 16,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 17),
                child: Text(
                  'Audio ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            height: 1,
          ),
          SizedBox(height: 19,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Please speak to ensure your microphone is working correctly.",
              style:GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: myprovider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Color(0xff5E5E66),
              ) ,)
          ],),
          SizedBox(height:14 ,),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Center(
              child: VolumeTest(),
            ),
          ),

          Row(
            children: [
              Transform.scale(
                scaleX: 28 / 59,
                scaleY: 13 / 34,
                child: Switch(
                  value: _isOverlayEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isOverlayEnabled = value;
                    });
                  },
                ),
              ),


              Text(
                "Echo cancellation",
                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height:3 ,),

          Row(
            children: [
              Transform.scale(
                scaleX: 28 / 59,
                scaleY: 13 / 34,
                child: Switch(
                  value: _isOverlayEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isOverlayEnabled = value;
                    });
                  },
                ),
              ),
              Text(
                "Noise suppression",
                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
              ),
            ],
          ),








        ],
      ),
    );
  }
}
