import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/widgets/brand_widgets/brand_sections.dart';
import 'package:streamore_app/widgets/brand_widgets/brand_theme_buttons.dart';
import '../../provider/my_provider.dart';
import '../../widgets/brand_widgets/brand_utils/font_utils.dart';
import '../../widgets/brand_widgets/section_header.dart';

class BrandTab extends StatefulWidget {
  const BrandTab({super.key});

  @override
  State<BrandTab> createState() => _BrandTabState();
}

class _BrandTabState extends State<BrandTab> {

  bool isThemeOptionsVisible = true;
  bool isColorOptionsVisible = true;
  bool isFontsVisible = true;
  bool isLogoVisible = true;
  bool isOverlayVisible = true;
  bool isBackgroundVisible = true;


  late TextEditingController _colorController;
  List<String> arabicFonts = [
    'Cairo',
    'Amiri',
    'Lalezar',
    'Tajawal',
    'Changa',
    'Reem Kufi',
    'Almarai',
    'El Messiri',
    'Noto Kufi Arabic',
    'Harmattan',
  ];
  List<String> englishFonts = [
    'Inter',
    'Poppins',
    'Playfair Display',
    'Pacifico',
    'Bebas Neue',
    'Courier Prime',
    'Abril Fatface',
    'Caveat',
    'Rubik Mono One',
    'Amatic SC',
    'DM Serif Display',
  ];

  @override
  void initState() {
    super.initState();
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    _colorController = TextEditingController(
      text:
          myProvider.primaryColor.value
              .toRadixString(16)
              .substring(2)
              .toUpperCase(),
    );
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    final bool isDark = myProvider.themeMode == ThemeMode.dark;
    final Color bgColor =
        isDark ? const Color(0xff0D142A) : const Color(0xffEFEFEF);

    final isArabic = context.locale.languageCode == 'ar';


    List<String> fontList = isArabic ? arabicFonts : englishFonts;


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: "theme".tr(),
            isVisible: isThemeOptionsVisible,
            onToggle:
                () => setState(
                  () => isThemeOptionsVisible = !isThemeOptionsVisible,
                ),
          ),
          if (isThemeOptionsVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children:
                    ["minimal", "bubble", "news"].map((theme) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: buildThemeButton(
                            context: context,
                            theme: theme,
                            selectedTheme: myProvider.selectedTheme,
                            onSelect:
                                (selected) =>
                                    myProvider.setSelectedTheme(selected),
                            primaryColor: myProvider.primaryColor,
                            themeMode: myProvider.themeMode,
                            font: myProvider.selectedFont,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

          SectionHeader(
            title: "primary_color".tr(),
            isVisible: isColorOptionsVisible,
            onToggle:
                () => setState(
                  () => isColorOptionsVisible = !isColorOptionsVisible,
                ),
          ),
          if (isColorOptionsVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: myProvider.primaryColor,
                            title: Text(
                              "select_a_color".tr(),
                              style: getFontStyle(
                                context,
                                myProvider.selectedFont,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: myProvider.primaryColor,
                                onColorChanged: (color) {
                                  myProvider.setPrimaryColor(color);
                                  _colorController.text =
                                      color.value
                                          .toRadixString(16)
                                          .substring(2)
                                          .toUpperCase();
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "done".tr(),
                                  style: getFontStyle(
                                    context,
                                    myProvider.selectedFont,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: myProvider.primaryColor,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 31,
                    height: 31,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: const Color(0xffC8C8C8)),
                    ),
                    child: const Center(
                      child: Text(
                        "#",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffC8C8C8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 99,
                    height: 31,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: const Color(0xffC8C8C8)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _colorController.text,
                      style: getFontStyle(
                        context,
                        myProvider.selectedFont,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

          SectionHeader(
            title: "fonts".tr(),
            isVisible: isFontsVisible,
            onToggle: () => setState(() => isFontsVisible = !isFontsVisible),
          ),
          if (isFontsVisible)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  DropdownButton2<String>(
                    isExpanded: true,
                    value:   fontList.contains(myProvider.selectedFont)
                        ? myProvider.selectedFont
                        : fontList.first,

                    items: fontList.toSet().map((font) {
                      return DropdownMenuItem<String>(
                        value: font,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            font,
                            style: getFontStyle(
                              context,
                              myProvider.selectedFont,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      Provider.of<MyProvider>(
                        context,
                        listen: false,
                      ).setSelectedFont(value!);
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 38,
                      width: 270,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade400),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 270,
                      offset: const Offset(0, 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xff5E5E66),
                          width: 1,
                        ),
                      ),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(0),
                        thumbVisibility: MaterialStateProperty.all(false),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Color(0xff5E5E66),
                        size: 20,
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 24,
                      padding: const EdgeInsets.only(left: 4, right: 21),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((
                          states,
                          ) {
                        if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed)) {
                          return const Color(0xff679FFF);
                        }
                        return null;
                      }),
                    ),
                  ),
                ],
              ),
            ),


          const LogoSection(),
          const OverlaySection(),
          const BackgroundSection(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
