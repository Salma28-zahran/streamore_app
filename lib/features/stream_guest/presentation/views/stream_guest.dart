import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/stream_guest/presentation/widgets/icons_stream.dart';
import 'package:streamore_app/features/stream_guest/presentation/widgets/tabs.dart';
import 'package:streamore_app/features/stream_guest/presentation/widgets/video.dart';
import 'package:streamore_app/widgets/permissions/camera/camera-permission.dart';
import 'package:streamore_app/widgets/permissions/mic/mic-permission.dart';


class StreamGuest extends StatefulWidget {
  static const String routeName = "/guest";
  final bool hasNotification;


  const StreamGuest({
    super.key,
    this.hasNotification = false,
  });

  @override
  State<StreamGuest> createState() => _StreamGuestState();
}

class _StreamGuestState extends State<StreamGuest>
    with TickerProviderStateMixin {
  bool _micOn = true;
  bool _camOn = true;
  late TabController _tabController;
  bool isZoomVisible = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController = TabController(length: 4, vsync: this);


  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final bool isSmall = size.width < 360;
    final double iconSize = isSmall ? 44.0 : 50.0;
    final myprovider = Provider.of<MyProvider>(context);
    final selectedTheme = myprovider.selectedTheme;
    final font = myprovider.selectedFont;
    final primaryColor = myprovider.primaryColor;
    final myProvider = Provider.of<MyProvider>(context);

    final double profileImageWidth = size.width * 0.9425;
    final double profileImageHeight = size.height * 0.28;
    final bool isDark = myprovider.themeMode == ThemeMode.dark;


    final commentProvider = Provider.of<CommentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/app_name.png"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                const Icon(FontAwesomeIcons.bell, size: 24),
                if (widget.hasNotification) // ✅ widget. صح هنا
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
      ),
      body: GestureDetector(
        onTap: () {
          commentProvider.clearTappedComments();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VideoWidget(
                        isZoomVisible: isZoomVisible,
                        profileImageWidth: profileImageWidth,
                        profileImageHeight: profileImageHeight,
                        onZoomIconClick: _onZoomIconClick,
                        onProfileImageClick: _onProfileImageClick,
                      ),


                    ],
                  ),
                ),
                IconsStream(
                  micOn: _micOn,
                  camOn: _camOn,
                  iconSize: iconSize,
                  isSmall: isSmall,
                  toggleMic: () => requestMicPermission(context, _toggleMic),
                  toggleCam: () =>
                      requestCameraPermission(context, _toggleCamera),

                ),
                SizedBox(height: 15,),
                TabsSection(
                  tabController: _tabController,
                  profileImageWidth: profileImageWidth,
                  isSmall: isSmall,
                )
              ],
            )
          ],
        ),
      ),

    );
  }

  void _onProfileImageClick() {
    setState(() {
      isZoomVisible = !isZoomVisible;
    });
  }

  void _onZoomIconClick() {
    Navigator.pushNamed(context, '/full_image');
  }

  void _toggleMic() {
    setState(() {
      _micOn = !_micOn;
    });
  }

  void _toggleCamera() {
    setState(() {
      _camOn = !_camOn;
    });
  }
}
