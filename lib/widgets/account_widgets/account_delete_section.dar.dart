import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/widgets/account_widgets/account_custombox.dart';

class AccountDeleteSection extends StatelessWidget {
  final bool isDark;
  final double w;
  final double h;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final ValueNotifier<bool> isFormFilledNotifier;
  final VoidCallback checkFormFilled;

  const AccountDeleteSection({
    required this.isDark,
    required this.w,
    required this.h,
    required this.controllers,
    required this.focusNodes,
    required this.isFormFilledNotifier,
    required this.checkFormFilled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: h * 0.02),
        Text(
          "delete_account".tr(),
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: h * 0.0135),
        Text(
          "permanently_delete_this_account_and_remove_all_associated".tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 11,
            color: isDark ? Colors.white : const Color(0xff5E5E66),
          ),
        ),
        SizedBox(height: h * 0.015),
        SizedBox(
          width: w * 0.265,
          height: h * 0.033,
          child: ElevatedButton(
            onPressed: () => _firstDeleteDialog(context, isDark, w, h),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme
                  .of(context)
                  .primaryColor,
              elevation: 0,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              "delete_account".tr(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _firstDeleteDialog(BuildContext context,
      bool isDark,
      double w,
      double h,) {
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final emailError = ValueNotifier<String?>(null);
    final passError = ValueNotifier<String?>(null);

    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            backgroundColor: Theme
                .of(context)
                .cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Center(
              child: Text(
                "delete_account".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            actionsPadding: const EdgeInsets.only(bottom: 10, right: 0),
            content: SizedBox(
              width: w,
              height: h * 0.34,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "this_will".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : Colors.grey,
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  ValueListenableBuilder<String?>(
                    valueListenable: emailError,
                    builder: (_, error, __) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "email".tr(),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            if (error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 8),
                                child: Text(
                                  error,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                  ),
                  SizedBox(height: h * 0.015),
                  ValueListenableBuilder<String?>(
                    valueListenable: passError,
                    builder: (_, error, __) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "password".tr(),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            if (error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 8),
                                child: Text(
                                  error,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                  ),
                  SizedBox(height: h * 0.02),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: w * 0.3,
                      height: h * 0.045,
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final pass = passController.text.trim();

                          emailError.value = null;
                          passError.value = null;

                          if (email.isEmpty || pass.isEmpty) {
                            if (email.isEmpty) {
                              emailError.value = "please_enter_your_email".tr();
                            }
                            if (pass.isEmpty) {
                              passError.value = "please_enter_your_password"
                                  .tr();
                            }
                            return;
                          }

                          final savedEmail = await StorageHelper.getEmail();
                          final savedPass = await StorageHelper.getPassword();

                          if (email != savedEmail || pass != savedPass) {
                            emailError.value = "enter_correct_email".tr();
                            passError.value = "enter_correct_password".tr();
                            return;
                          }

                          Navigator.pop(context);
                          _secondDeleteDialog(context, isDark, w, h);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "next".tr(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _secondDeleteDialog(BuildContext context,
      bool isDark,
      double w,
      double h,) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: w * 0.106),
            backgroundColor: Theme
                .of(context)
                .cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            content: SizedBox(
              width: w * 0.915,
              height: h * 0.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "authentication_required".tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.018),
                  Text(
                    "to_finish".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : Colors.grey,
                    ),
                  ),
                  SizedBox(height: h * 0.036),
                  Center(
                    child: Wrap(
                      spacing: w * 0.008,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        6,
                            (i) =>
                            AccountCustombox(
                              controller: controllers[i],
                              focusNode: focusNodes[i],
                              nextFocus: i < 5 ? focusNodes[i + 1] : null,
                              onChanged: (_) => checkFormFilled(),
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: isFormFilledNotifier,
                        builder: (_, filled, __) =>
                            ElevatedButton(
                              onPressed: filled
                                  ? () => Navigator.pop(context)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                filled ? Colors.red : Colors.grey.shade400,
                                minimumSize: Size(w * 0.368, h * 0.051),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                "delete_account".tr(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
