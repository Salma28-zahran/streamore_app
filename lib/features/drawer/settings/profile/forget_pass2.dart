import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/verify_widgets/custombox_verify.dart';

class ForgetPass2 extends StatefulWidget {
  static const String routeName = "/forget_pass2";
  const ForgetPass2({super.key});

  @override
  State<ForgetPass2> createState() => _ForgetPass2State();
}

class _ForgetPass2State extends State<ForgetPass2> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool get isFormFilled =>
      _controllers.every((controller) => controller.text.trim().isNotEmpty);

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_onInputChanged);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;
    final double hp = w * 0.06;
    final double topPadding = h * 0.1;
    final double spacing = w * 0.04;
    final double buttonWidth = w * 0.37;
    final double buttonHeight = h * 0.05;
    final double fontSizeLarge = w * 0.05;
    final double fontSizeMedium = w * 0.038;
    final double fontSizeSmall = w * 0.032;
    const bool hasNotification = false;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

      body: Padding(
        padding: EdgeInsets.only(top: h * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Text(
                "change_password".tr(),
                style: GoogleFonts.poppins(
                  fontSize: fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child:
                  Center(child: Image.asset("assets/images/app_name2.png")),
                ),
                SizedBox(height: h * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: fontSizeMedium,
                        ),
                        children: [
                          TextSpan(
                            text:
                            '${'enter_the_confirmation_code_we_sent_to'.tr()}\n',
                          ),
                          TextSpan(
                            text: 'b****32@gmail.com ',
                          ),
                          TextSpan(
                            text: 'resent_code'.tr(),
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: fontSizeSmall,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.05),
                Wrap(
                  spacing: spacing,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    6,
                        (index) => CustomboxVerify(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      nextFocus:
                      index < 5 ? _focusNodes[index + 1] : null,
                    ),
                  ),
                ),
                SizedBox(height: h * 0.045),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isFormFilled
                          ? () {
                        Navigator.pushNamed(
                            context, '/forget_pass3');
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormFilled
                            ? Color(0xff1865E8)
                            : Colors.grey.shade400,
                        minimumSize: Size(buttonWidth, buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        "next".tr(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSizeSmall,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
