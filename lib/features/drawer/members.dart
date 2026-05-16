import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/member_widgets/invite_member_dialog.dart';
import 'package:streamore_app/widgets/member_widgets/member_search_and_filter.dart';
import 'package:streamore_app/widgets/member_widgets/member_header_row.dart';
import 'package:streamore_app/widgets/member_widgets/member_list_item.dart';

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

            MemberSearchAndFilter(
              selectedValue: selectedValue,
              onChanged: (val) {
                setState(() => selectedValue = val);
              },
              roles: items,
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
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor),
                  SizedBox(width: mq.width * 0.01),
                  Text(
                    "invite_a_member".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: mq.width * 0.035,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: mq.height * 0.04),

            const MemberHeaderRow(),

            Expanded(
              child: ListView.builder(
                itemCount: membersList.length,
                itemBuilder: (context, index) {
                  final member = membersList[index];
                  return MemberListItem(
                    member: member,
                    onRemove: () => removeMember(index),
                    fontSize: mq.width * 0.03,
                    iconSize: mq.width * 0.05,
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
