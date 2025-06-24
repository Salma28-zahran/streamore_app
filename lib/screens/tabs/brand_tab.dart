import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../my_provider.dart';

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
  List<String> fontList = ['Inter', 'Roboto', 'Poppins'];
  String selectedFont = 'Inter';
  List<String> fontSizes = ['S', 'M', 'L'];
  String selectedSize = 'S';

  @override
  void initState() {
    super.initState();
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    _colorController = TextEditingController(
      text: myProvider.primaryColor.value.toRadixString(16).substring(2).toUpperCase(),
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
    Color bgColor = isDark ? const Color(0xff0D142A) : const Color(0xffEFEFEF);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionHeader(
            title: "Theme",
            isVisible: isThemeOptionsVisible,
            onToggle: () => setState(() => isThemeOptionsVisible = !isThemeOptionsVisible),
          ),
          if (isThemeOptionsVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: ['Minimal', 'Bubble', 'News'].map((theme) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildThemeButton(
                        context: context,
                        theme: theme,
                        selectedTheme: myProvider.selectedTheme,
                        onSelect: (selected) => myProvider.setSelectedTheme(selected),
                        primaryColor: myProvider.primaryColor,
                        themeMode: myProvider.themeMode,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          buildSectionHeader(
            title: "Primary Color",
            isVisible: isColorOptionsVisible,
            onToggle: () => setState(() => isColorOptionsVisible = !isColorOptionsVisible),
          ),
          if (isColorOptionsVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: myProvider.primaryColor,
                            title: const Text(
                              "Select a Color",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: myProvider.primaryColor,
                                onColorChanged: (color) {
                                  myProvider.setPrimaryColor(color);
                                  _colorController.text = color.value.toRadixString(16).substring(2).toUpperCase();
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Done", style: TextStyle(color: Colors.white)),
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
                      child: Text("#", style: TextStyle(fontSize: 18, color: Color(0xffC8C8C8))),
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
                      '${myProvider.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

          buildSectionHeader(
            title: "Fonts",
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
                    value: selectedFont,
                    items: fontList.map((font) {
                      return DropdownMenuItem<String>(
                        value: font,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            font,
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
                    onChanged: (value) {
                      setState(() {
                        selectedFont = value!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 38,
                      width: 270,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade400),
                        color: Colors.white,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 270,
                      offset: const Offset(0, 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xff5E5E66), width: 1),
                      ),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(0),
                        thumbVisibility: MaterialStateProperty.all(false),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down_outlined, color: Color(0xff5E5E66), size: 20),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 24,
                      padding: const EdgeInsets.only(left: 4, right: 21),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered) ||
                              states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return const Color(0xff679FFF);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("S", style: GoogleFonts.inter(fontSize: 33, fontWeight: FontWeight.w400, color: const Color(0xff5E5E66))),
                ],
              ),
            ),

          buildLogoSection(),
          buildOverlaySection(),
          buildBackgroundSection(),
          SizedBox(height: 100),

        ],
      ),
    );
  }

  Widget buildSectionHeader({required String title, required bool isVisible, required VoidCallback onToggle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
      child: GestureDetector(
        onTap: onToggle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Icon(isVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget buildLogoSection() {
    return Column(
      children: [
        buildSectionHeader(
          title: "Logo",
          isVisible: isLogoVisible,
          onToggle: () => setState(() => isLogoVisible = !isLogoVisible),
        ),
        if (isLogoVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                _buildImageBox(image: Image.asset("assets/images/logo.png", width: 40)),
                const SizedBox(width: 10),
                _buildAddBox(),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildOverlaySection() {
    return Column(
      children: [
        buildSectionHeader(
          title: "Overlay",
          isVisible: isOverlayVisible,
          onToggle: () => setState(() => isOverlayVisible = !isOverlayVisible),
        ),
        if (isOverlayVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(7, (index) => _buildImageBox())
                ..add(_buildAddBox()),
            ),
          ),
      ],
    );
  }

  Widget buildBackgroundSection() {
    return Column(
      children: [
        buildSectionHeader(
          title: "Background",
          isVisible: isBackgroundVisible,
          onToggle: () => setState(() => isBackgroundVisible = !isBackgroundVisible),
        ),
        if (isBackgroundVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(7, (index) => _buildImageBox())
                ..add(_buildAddBox()),
            ),
          ),
      ],
    );
  }

  Widget _buildImageBox({Image? image}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[300],
      ),
      child: image != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: image,
      )
          : null,
    );
  }

  Widget _buildAddBox() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
        color: Colors.white,
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.black54),
      ),
    );
  }


  Widget _buildThemeButton({
    required BuildContext context,
    required String theme,
    required String selectedTheme,
    required Function(String) onSelect,
    required Color primaryColor,
    required ThemeMode themeMode,
  }) {
    final bool isSelected = theme == selectedTheme;
    final bool isDark = themeMode == ThemeMode.dark;
    Color bgColor = isDark ? const Color(0xff0D142A) : const Color(0xffEFEFEF);

    switch (theme) {
      case 'Minimal':
        return _buildMinimalButton(theme, isSelected, primaryColor, bgColor, onSelect);
      case 'Bubble':
        return _buildBubbleButton(theme, isSelected, primaryColor, bgColor, onSelect);
      case 'News':
        return _buildNewsButton(theme, isSelected, primaryColor, bgColor, onSelect);
      default:
        return const SizedBox();
    }
  }

  Widget _buildMinimalButton(String theme, bool isSelected, Color primaryColor, Color bgColor, Function(String) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(theme),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: isSelected ? primaryColor : const Color(0xffC8C8C8)),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 23, color: primaryColor),
              const SizedBox(width: 5),
              Container(
                width: 62,
                height: 22,
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Minimal',
                    style: GoogleFonts.poppins(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubbleButton(String theme, bool isSelected, Color primaryColor, Color bgColor, Function(String) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(theme),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: isSelected ? primaryColor : const Color(0xffC8C8C8)),
        ),
        child: Center(
          child: Container(
            width: 62,
            height: 23,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                'Bubble',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsButton(String theme, bool isSelected, Color primaryColor, Color bgColor, Function(String) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(theme),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xffC8C8C8)),
        ),
        child: Center(
          child: Container(
            width: 70,
            height: 23,
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade400),
            ),
            child: Center(
              child: Text(
                'News',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
    );
  }
}