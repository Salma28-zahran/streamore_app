import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:streamore_app/my_provider.dart' show MyProvider;
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';


class Camera extends StatefulWidget {
  static const routeName = "/camera";

  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  bool _isOverlayEnabled = false;
  bool _isOverlayEnabled2 = false;



  @override
  Widget build(BuildContext context) {
    bool hasNotification = false;
    var myprovider = Provider.of<MyProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(hasNotification: false),


      drawer: MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon:  Icon(
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
                  'camera'.tr(),
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 22),
                child: Container(
                  width: 385,
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    "assets/images/camera.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),

            ],
          ),
          //SizedBox(height: 24,),
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
                "flip_camera".tr(),
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
                  value: _isOverlayEnabled2,
                  onChanged: (value) {
                    setState(() {
                      _isOverlayEnabled2 = value;
                    });
                  },
                ),
              ),
              Text(
                "mirror_camera".tr(),
                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
