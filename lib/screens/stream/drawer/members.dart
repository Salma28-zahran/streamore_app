import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/invite_member_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    bool hasNotification = false;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).primaryColorDark,
                  size: 24,
                ),
                if (hasNotification)
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "members".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            SizedBox(height: 21),
            Row(
              children: [
                SizedBox(
                  width: 218,
                  height: 34,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "search".tr(),
                      hintStyle: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontSize: 12,
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
                SizedBox(width: 18),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            'select_a_role'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
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
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            item.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
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
                      height: 34,
                      width: 125,
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
                      iconSize: 18,
                      iconEnabledColor: Color(0xff5E5E66),
                      iconDisabledColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      offset: Offset(0, -1),
                      maxHeight: 70,
                      width: 125,
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
                      height: 24,
                      padding: EdgeInsets.only(left: 4, right: 21),
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
            SizedBox(height: 10),
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
                minimumSize: Size(141, 38),
                side: BorderSide(
                  color: Color(0xff1865E8),
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
                  Icon(Icons.add, color: Theme.of(context).primaryColor),
                  SizedBox(width: 5),
                  Text(
                    "invite_a_member".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1865E8),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 31),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "member".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 65),
                  child: Text(
                    "role".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
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
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(member['email'] ?? '',
                              style: GoogleFonts.poppins(fontSize: 12)),
                          Row(
                            children: [
                              Text(member['role'] ?? '',
                                  style: GoogleFonts.poppins(fontSize: 12)),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    membersList.removeAt(index);
                                  });
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