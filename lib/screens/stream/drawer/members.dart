import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/invite_member_dialog.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/my_provider.dart';

class Members extends StatefulWidget {
  static const String routeName = "/members";

  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final List<String> items = [
    'admin',
    'guest',
  ];

  List<Map<String, String>> membersList = [];

  String? selectedValue;

  void addMember(String email, String role) {
    setState(() {
      membersList.add({
        'email': email,
        'role': role.tr(),
      });
    });
  }

  void removeMember(int index) {
    setState(() {
      membersList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    bool hasNotification = false;
    var myprovider = Provider.of<MyProvider>(context);
    bool isDark = myprovider.themeMode == ThemeMode.dark;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

      body: Padding(
        padding: EdgeInsets.only(
          left: mq.width * 0.025,
          right: mq.width * 0.045,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mq.height * 0.02),
            Text(
              "members".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: mq.width * 0.03,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            SizedBox(height: mq.height * 0.025),
            Row(
              children: [
                SizedBox(
                  width: mq.width * 0.55,
                  height: mq.height * 0.045,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "search".tr(),
                      hintStyle: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontSize: mq.width * 0.03,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Color(0xff5E5E66),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Color(0xff5E5E66),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(
                          color: Color(0xff5E5E66),
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                SizedBox(width: mq.width * 0.045),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: mq.width * 0.04,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: mq.width * 0.005),
                        Expanded(
                          child: Text(
                            'select_a_role'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: mq.width * 0.03,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textTheme.bodyLarge?.color!,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsets.only(left: mq.width * 0.02),
                          child: Text(
                            item.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: mq.width * 0.03,
                              fontWeight: FontWeight.w400,
                              color:
                              isDark ? Colors.white : Theme.of(context).primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: mq.height * 0.045,
                      width: mq.width * 0.3,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff5E5E66),
                        ),
                        color: Theme.of(context).cardColor,
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                      iconSize: mq.width * 0.045,
                      iconEnabledColor: Color(0xff5E5E66),
                      iconDisabledColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      offset: Offset(0, -1),
                      maxHeight: mq.height * 0.09,
                      width: mq.width * 0.3,
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
                        thumbVisibility: MaterialStateProperty.all(false),
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: mq.height * 0.03,
                      padding: EdgeInsets.only(
                        left: mq.width * 0.01,
                        right: mq.width * 0.05,
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
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
            SizedBox(height: mq.height * 0.015),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => InviteMemberDialog(
                    selectedRole: selectedValue,
                    onRoleChanged: (val) {
                      setState(() => selectedValue = val);
                    },
                    onInvite: (email, role) {
                      addMember(email, role);
                    },
                    roles: items,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(mq.width * 0.35, mq.height * 0.05),
                side: BorderSide(
                    color:
                    isDark ? Colors.white : Theme.of(context).primaryColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add,
                      color:
                      isDark ? Colors.white : Theme.of(context).primaryColor),
                  SizedBox(width: mq.width * 0.01),
                  Text(
                    "invite_a_member".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: mq.width * 0.035,
                      fontWeight: FontWeight.w400,
                        color:
                        isDark ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mq.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "member".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: mq.width * 0.025,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: mq.width * 0.15),
                  child: Text(
                    "role".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: mq.width * 0.025,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: membersList.length,
                itemBuilder: (context, index) {
                  final member = membersList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: mq.height * 0.005),
                    child: Container(
                      height: mq.height * 0.055,
                      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey,
                        ),

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(member['email'] ?? '',
                              style: GoogleFonts.poppins(fontSize: mq.width * 0.03)),
                          Row(
                            children: [
                              Text(member['role'] ?? '',
                                  style: GoogleFonts.poppins(fontSize: mq.width * 0.03)),
                              SizedBox(width: mq.width * 0.025),
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                iconSize: mq.width * 0.05,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  removeMember(index);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
