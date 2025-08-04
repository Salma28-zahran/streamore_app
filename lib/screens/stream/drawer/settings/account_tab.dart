import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/my_provider.dart';
import 'package:streamore_app/widgets/account_widgets/account_custombox.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  late ValueNotifier<bool> isFormFilledNotifier;

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes  = List.generate(6, (_) => FocusNode());

  bool get isFormFilled =>
      _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    isFormFilledNotifier = ValueNotifier(false);
    for (var c in _controllers) {
      c.addListener(_checkFormFilled);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    isFormFilledNotifier.dispose();
    super.dispose();
  }

  void _checkFormFilled() {
    isFormFilledNotifier.value =
        _controllers.every((c) => c.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final mq   = MediaQuery.of(context);
    final w    = mq.size.width;
    final h    = mq.size.height;
    return Consumer<MyProvider>(
      builder: (context, myprovider, _) {
        final isDark = myprovider.themeMode == ThemeMode.dark;
        return Padding(
          padding: EdgeInsets.only(
            left: w * 0.06,
            right: w * 0.06,
            top: h * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("profile_info".tr(),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 16)),
              SizedBox(height: h * 0.0075),
              Text(
                "edit_profile_to_update_your_personal_details_and_preferences".tr(),
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
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text("edit_profile".tr(),
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: h * 0.022),
              Text("team_name".tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: h * 0.016),
              SizedBox(
                width: w * 0.707, // 265/375
                height: h * 0.033, // 34/667
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: isDark
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    contentPadding: EdgeInsets.only(bottom: 8),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: isDark
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.003),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1865E8),
                  minimumSize: Size(w * 0.27, h * 0.033),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text("update".tr(),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: h * 0.01),
              Text("theme".tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: h * 0.016),
              SizedBox(
                width: w * 0.315, // 130/375
                height: h * 0.033,
                child: ElevatedButton(
                  onPressed: myprovider.changeTheme,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    side: BorderSide(
                        color: isDark
                            ? Colors.amber
                            : Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: w * 0.021),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round,
                          size: 14,
                          color: isDark
                              ? Colors.amber
                              : Theme.of(context).primaryColor),
                      SizedBox(width: w * 0.016),
                      Text(isDark ? "light_theme".tr() : "dark_theme".tr(),
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.amber
                                  : Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),
              Text("your_accounts".tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: h * 0.0045),
              Text(
                "permanently_delete_this_account_and_remove_all_associated".tr(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color:
                    isDark ? Colors.white : const Color(0xff5E5E66)),
              ),
              SizedBox(height: h * 0.009),
              SizedBox(
                width: w * 0.265,
                height: h * 0.033,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text("add_account".tr(),
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: h * 0.0077),
              SizedBox(
                width: w * 0.216,
                height: h * 0.033,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text("logout".tr(),
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
              SizedBox(height: h * 0.02),
              Text("delete_account".tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: h * 0.0135),
              Text(
                "permanently_delete_this_account_and_remove_all_associated".tr(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color:
                    isDark ? Colors.white : const Color(0xff5E5E66)),
              ),
              SizedBox(height: h * 0.015),
              SizedBox(
                width: w * 0.265,
                height: h * 0.033,
                child: ElevatedButton(
                  onPressed: () => _firstDeleteDialog(context, isDark, w, h),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text("delete_account".tr(),
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  void _firstDeleteDialog(BuildContext context, bool isDark, double w, double h) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Center(
          child: Text("delete_account".tr(),
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black)),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        actionsPadding: const EdgeInsets.only(bottom: 10, right: 0),
        content: SizedBox(
          width: w * 1,
          height: h * 0.18, // 180/667
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "this_will".tr(),
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : Colors.grey),
              ),
              SizedBox(height: h * 0.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _secondDeleteDialog(context, isDark, w, h);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(w * 0.805, h * 0.051), // 302/375, 34/667
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: Text("delete_account".tr(),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _secondDeleteDialog(BuildContext context, bool isDark, double w, double h) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: w * 0.106), //40/375
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        content: SizedBox(
          width: w * 0.915,
          height: h * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("authentication_required".tr(),
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black)),
              ),
              SizedBox(height: h * 0.018),
              Text(
                "to_finish".tr(),
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color:
                    isDark ? Colors.white : Colors.grey),
              ),
              SizedBox(height: h * 0.036),
              Center(
                child: Wrap(
                  spacing: w * 0.008,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    6,
                        (i) => AccountCustombox(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      nextFocus: i < 5 ? _focusNodes[i + 1] : null,
                      onChanged: (_) => _checkFormFilled(),
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
                    builder: (_, filled, __) => ElevatedButton(
                      onPressed: filled ? () => Navigator.pop(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        filled ? Colors.red : Colors.grey.shade400,
                        minimumSize: Size(w * 0.368, h * 0.051),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text("delete_account".tr(),
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
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
