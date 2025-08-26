import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';

class AccountMainSection extends StatelessWidget {
  final bool isDark;
  final double w;
  final double h;

  const AccountMainSection({
    super.key,
    required this.isDark,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    final myprovider = context.read<MyProvider>();
    final token = "b7371be46ffa4d55630dc762a2377c527e94f5d0";


    return Column(
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
          width: w * 0.707,
          height: h * 0.033,
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
              contentPadding: const EdgeInsets.only(bottom: 8),
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
          width: w * 0.315,
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
              color: isDark ? Colors.white : const Color(0xff5E5E66)),
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
            onPressed: () {
              // استدعاء Cubit للـ Logout
              context.read<AuthCubit>().logout();
            },
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
      ],
    );
  }
}
