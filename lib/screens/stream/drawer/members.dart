import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

class Members extends StatefulWidget {
  static const String routeName = "/members";

  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final List<String> items = [
    'admin'.tr(),
    'guest'.tr(),
  ];

  String? selectedValue;

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
            padding: const EdgeInsets.only(right: 10,left: 10),
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
        padding: EdgeInsets.only(left: 10,right: 18),
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
                Container(
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
                        borderSide: BorderSide(
                          color: Color(0xff5E5E66),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(
                          color: Color(0xff5E5E66),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color:
                              Theme.of(context).textTheme.bodyLarge?.color!,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
                        .toList(),
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
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                      iconSize: 18,
                      iconEnabledColor: Color(0xff5E5E66),
                      iconDisabledColor:
                      Theme.of(context).tabBarTheme.unselectedLabelColor,
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print('clicked');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                                          items: items
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
                                          value: selectedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValue = value;
                                            });
                                          },
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
                                            iconDisabledColor:
                                            Theme.of(context).tabBarTheme.unselectedLabelColor,
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
                                              thumbVisibility: MaterialStateProperty.all(false),
                                            ),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            height: 24,
                                            padding: EdgeInsets.only(left: 4, right: 21),
                                            overlayColor: MaterialStateProperty.resolveWith<Color?>(
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
                                SizedBox(height: 28,),
                                SizedBox(
                                  width: 284,
                                  height: 34,
                                  child: ElevatedButton(
                                    onPressed: () {
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
                  },
                );
              },
              style:
              ElevatedButton.styleFrom(
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
            )
          ],
        ),
      ),
    );
  }
}