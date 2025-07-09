import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class InviteMemberDialog extends StatelessWidget {
  final List<String> roles;
  final String? selectedRole;
  final Function(String?) onRoleChanged;
  final void Function(String email, String role) onInvite;

  const InviteMemberDialog({
    super.key,
    required this.onInvite,
    required this.onRoleChanged,
    required this.roles,
    required this.selectedRole,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      content: Stack(
        children: [
          Container(
            width: 319,
            height: 295,
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24),
                Text(
                  'invite_a_member'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Container(
                    width: 228,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'lorem_ipsum_dolor_sit_amet_consectetur'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5E5E66),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Text(
                            'adipisicing_elit'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff5E5E66),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          "email".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 284,
                        height: 34,
                        child: TextField(
                          controller: emailController,
                          style: GoogleFonts.poppins(fontSize: 12),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Colors.grey.shade700,
                                width: 1.5,
                              ),
                            ),
                            hintText: "enter_email".tr(),
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          "role".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'select_a_role'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          items: roles
                              .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ))
                              .toList(),
                          value: selectedRole,
                          onChanged: onRoleChanged,
                          buttonStyleData: ButtonStyleData(
                            height: 38,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            elevation: 0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffC1C1C1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            iconSize: 18,
                            iconEnabledColor: Color(0xff5E5E66),
                            iconDisabledColor: Theme.of(context)
                                .tabBarTheme
                                .unselectedLabelColor,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            offset: Offset(0, 5),
                            maxHeight: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xff5E5E66),
                                width: 1,
                              ),
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: Radius.circular(40),
                              thickness: MaterialStateProperty.all(0),
                              thumbVisibility:
                              MaterialStateProperty.all(false),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: 24,
                            padding: EdgeInsets.only(left: 4, right: 21),
                            overlayColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered) ||
                                    states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed)) {
                                  return Color(0xff679FFF);
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                SizedBox(
                  width: 284,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          selectedRole != null) {
                        onInvite(emailController.text.trim(), selectedRole!);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'invite'.tr(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 15,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
