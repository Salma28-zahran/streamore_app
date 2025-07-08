import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

class ForgetPass3 extends StatefulWidget {
  static const String routeName = "/forget_pass3";
  const ForgetPass3({super.key});

  @override
  State<ForgetPass3> createState() => _ForgetPass3State();
}

class _ForgetPass3State extends State<ForgetPass3> {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  String? passwordError;

  @override
  void dispose() {
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;
    final double hp = w * 0.06;
    final double fieldHeight = h * 0.065;
    final double verticalSpacing = h * 0.015;
    final double buttonHeight = h * 0.07;
    final double textFontSize = w * 0.04;
    const bool hasNotification = false;

    return Scaffold(
      drawer:  MainDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Image.asset("assets/images/app_name.png"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hp * 0.4),
            child: Stack(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).primaryColorDark,
                  size: w * 0.06,
                ),
                if (hasNotification)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: w * 0.01,
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(h * 0.001),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            height: h * 0.001,
          ),
        ),
      ),
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
                  fontSize: textFontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),
            CustomInputs.buildTextField(
              context: context,
              label: "new_password".tr(),
              controller: newPassController,
              isPassword: true,
              height: fieldHeight,
              fontSize: textFontSize,
            ),
            CustomInputs.buildTextField(
              context: context,
              label: "confirm_password".tr(),
              controller: confirmPassController,
              isPassword: true,
              height: fieldHeight,
              fontSize: textFontSize,
            ),
            if (passwordError != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.005),
                child: Text(
                  passwordError!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: textFontSize * 0.85,
                  ),
                ),
              ),
            SizedBox(height: h * 0.03),
            CustomInputs.buildConfirmButton(
              context: context,
              text:  "confirm".tr(),
              onPressed: () {
                setState(() {
                  if (newPassController.text != confirmPassController.text) {
                    passwordError = "password_not_match".tr();
                  } else {
                    passwordError = null;
                    Navigator.pushNamed(context, "/Settings");
                  }
                });
              },
              height: buttonHeight,
              fontSize: textFontSize,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInputs {
  static Widget buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required double height,
    required double fontSize,
    bool isPassword = false,
  }) {
    final double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: w * 0.03),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: w * 0.015),
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.symmetric(horizontal: w * 0.03),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: false,
                contentPadding: EdgeInsets.symmetric(vertical: height * 0.25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildConfirmButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    required double height,
    required double fontSize,
  }) {
    final double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E63F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}