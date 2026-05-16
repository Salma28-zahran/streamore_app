import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class ChangePassword extends StatefulWidget {
  static const String routeName = "/change_pass";

  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late final TextEditingController currentPassController;
  late final TextEditingController newPassController;
  late final TextEditingController confirmPassController;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    currentPassController = TextEditingController();
    newPassController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  @override
  void dispose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    if (newPassController.text != confirmPassController.text) {
      setState(() {
        passwordError = "passwords_do_not_match".tr();
      });
    } else {
      setState(() {
        passwordError = null;
      });
      Navigator.pushNamed(context, "/Settings");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;
    final double hp = w * 0.06;
    const bool hasNotification = false;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: h * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Text(
                "change_password".tr(),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            customTextField(
              context: context,
              label: "current_password".tr(),
              controller: currentPassController,
              isPassword: true,
            ),
            customTextField(
              context: context,
              label: "new_password".tr(),
              controller: newPassController,
              isPassword: true,
            ),
            customTextField(
              context: context,
              label: "confirm_password".tr(),
              controller: confirmPassController,
              isPassword: true,
            ),

            if (passwordError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 4),
                child: Text(
                  passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/forget_pass1");
                },
                child: Text(
                  "forgot_your_current_password".tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _validateAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "confirm".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

Widget customTextField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  final media = MediaQuery.of(context).size;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 6),
      Container(
        width: double.infinity,
        height: 34,
        margin: const EdgeInsets.symmetric(horizontal: 23),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isCollapsed: false,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
      SizedBox(height: media.height * 0.02),
    ],
  );
}
