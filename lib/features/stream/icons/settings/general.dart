import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/stream/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class General extends StatefulWidget {
  static const routeName = "/general";

  const General({super.key});

  @override
  State<General> createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  late String selectedOrientation;
  String? selectedValue;
  bool hasNotification = false;

  final List<String> items = [
    'high_definition_720p'.tr(),
    'medium_definition_480p'.tr(),
    "low_definition_144p".tr()
  ];

  @override
  void initState() {
    super.initState();
    final myprovider = Provider.of<MyProvider>(context, listen: false);
    selectedOrientation = myprovider.orientation;
  }

  @override
  Widget build(BuildContext context) {
    final myprovider = Provider.of<MyProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (myprovider.orientation == "landscape") {
          Navigator.pushReplacementNamed(context, "/full_image");
        } else {
          Navigator.pushReplacementNamed(context, "/stream");
        }
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(hasNotification: false),

        drawer: MainDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Row
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: myprovider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 16,
                    ),
                    onPressed: () => Navigator.pop(context),

                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 17),
                    child: Text(
                      'general'.tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: myprovider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              Divider(
                color: Theme.of(context).dividerColor,
                thickness: 0.5,
                height: 1,
              ),

              // Stream Quality
              Padding(
                padding: const EdgeInsets.only(left: 21, top: 24, right: 21),
                child: Text(
                  "stream_quality".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            'high_definition_720p'.tr(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color!,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
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
                      width: 262,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff5E5E66)),
                        color: Theme.of(context).cardColor,
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                      iconSize: 18,
                      iconEnabledColor: Color(0xff5E5E66),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      offset: const Offset(0, -1),
                      maxHeight: 90,
                      width: 262,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xff5E5E66)),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 24,
                      padding: EdgeInsets.only(left: 4, right: 21),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Name Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Text(
                  "name".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: SizedBox(
                  width: 262,
                  height: 34,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "enter_your_name".tr(),
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xff676767),
                        fontSize: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide:
                        const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Orientation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Text(
                  "orientation".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Row(
                  children: [
                    Radio<String>(
                      value: "portrait",
                      groupValue: selectedOrientation,
                      activeColor: Theme.of(context).primaryColor,
                      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return myprovider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black;
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedOrientation = value!;
                          myprovider.orientation = value;
                        });
                      },
                    ),
                    Container(
                      width: 15,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: myprovider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Radio<String>(
                      value: "landscape",
                      groupValue: selectedOrientation,
                      activeColor: Theme.of(context).primaryColor,
                      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return myprovider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black;
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedOrientation = value!;
                          myprovider.orientation = value;
                          myprovider.setShouldGoToFullImage(value == "landscape");
                        });
                      },
                    ),
                    Container(
                      width: 30,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: myprovider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
