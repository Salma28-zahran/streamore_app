import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/my_provider.dart';

class InviteMemberDialog extends StatefulWidget {
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
  State<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends State<InviteMemberDialog> {
  final TextEditingController emailController = TextEditingController();
  String? localSelectedRole;

  @override
  void initState() {
    super.initState();
    localSelectedRole = widget.selectedRole;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    var myprovider = Provider.of<MyProvider>(context);
    bool isDark = myprovider.themeMode == ThemeMode.dark;


    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      content: Stack(
        children: [
          Container(
            width: mq.width * 0.85,
            height: mq.height * 0.45,
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: mq.height * 0.03),
                Text(
                  'invite_a_member'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: mq.width * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: mq.height * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: mq.width * 0.1),
                  child: Container(
                    width: mq.width * 0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'lorem_ipsum_dolor_sit_amet_consectetur'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: mq.width * 0.025,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff5E5E66),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: mq.width * 0.15),
                          child: Text(
                            'adipisicing_elit'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: mq.width * 0.025,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff5E5E66),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: mq.width * 0.01),
                        child: Text(
                          "email".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: mq.width * 0.032,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: mq.height * 0.005),
                      Container(
                        width: mq.width * 0.75,
                        height: mq.height * 0.05,
                        child: TextField(
                          controller: emailController,
                          style: GoogleFonts.poppins(fontSize: mq.width * 0.03),
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
                              fontSize: mq.width * 0.03,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mq.height * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: mq.width * 0.01),
                        child: Text(
                          "role".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: mq.width * 0.032,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: mq.height * 0.005),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'select_a_role'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: mq.width * 0.03,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          items: widget.roles
                              .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.poppins(
                                fontSize: mq.width * 0.03,
                                fontWeight: FontWeight.w400,
                                  color:
                                  isDark ? Colors.white : Theme.of(context).primaryColor,                              ),
                            ),
                          ))
                              .toList(),
                          value: localSelectedRole,
                          onChanged: (val) {
                            setState(() {
                              localSelectedRole = val;
                            });

                          },
                          buttonStyleData: ButtonStyleData(
                            height: mq.height * 0.06,
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
                            iconSize: mq.width * 0.045,
                            iconEnabledColor: Color(0xff5E5E66),
                            iconDisabledColor: Theme.of(context)
                                .tabBarTheme
                                .unselectedLabelColor,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            offset: Offset(0, 5),
                            maxHeight: mq.height * 0.1,
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
                            height: mq.height * 0.04,
                            padding: EdgeInsets.only(
                                left: mq.width * 0.01,
                                right: mq.width * 0.05),
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
                SizedBox(height: mq.height * 0.035),
                SizedBox(
                  width: mq.width * 0.75,
                  height: mq.height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          localSelectedRole != null) {
                        widget.onInvite(
                            emailController.text.trim(), localSelectedRole!);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),

                      ),

                      elevation: 0,
                    ),
                    child: Text(
                      'invite'.tr(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: mq.width * 0.035,
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
                size: mq.width * 0.04,
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
