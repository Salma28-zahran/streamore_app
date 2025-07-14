import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streamore_app/my_provider.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class Profile extends StatefulWidget {
  static const String routeName = "/profile";

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<String> items = ['egypt'.tr(), 'ksa'.tr()];
  final Map<String, String> countryCodes = {
    'egypt'.tr(): '+20',
    'ksa'.tr(): '+966',
  };

  String? selectedCountry;
  String? selectedCode;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;
    final double hp = w * 0.06;
    const double avatarSize = 120;
    final double fieldHeight = h * 0.045;
    final double halfFieldWidth = (w - hp * 2 - 26) / 2;
    final double fullFieldWidth = w - hp * 2;
    final double buttonHeight = fieldHeight;
    const bool hasNotification = false;
    final myProvider = Provider.of<MyProvider>(context);
    final bool isDark = myProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: h * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Text('edit_profile'.tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: h * 0.02),
            Align(
              alignment: Alignment.center,
              child: ClipOval(
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  color: Colors.grey[300],
                  child: _imageFile == null
                      ? const Icon(Icons.person_rounded,
                      size: 90, color: Colors.white70)
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: h * 0.02),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: w * 0.4,
                height: buttonHeight,
                child: OutlinedButton(
                  onPressed: _pickImage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(
                        color: isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  child: Text('choose_an_image'.tr(),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ),
            ),
            SizedBox(height: h * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabeledField(
                      label: 'first_name'.tr(),
                      width: halfFieldWidth,
                      height: fieldHeight),
                  _buildLabeledField(
                      label: 'last_name'.tr(),
                      width: halfFieldWidth,
                      height: fieldHeight),
                ],
              ),
            ),
            SizedBox(height: h * 0.018),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: _buildSingleField(
                  label: 'email'.tr(),
                  width: fullFieldWidth,
                  height: fieldHeight),
            ),
            SizedBox(height: h * 0.018),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Text('country'.tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: h * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Icon(Icons.list,
                          size: 16, color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text('select_your_country'.tr(),
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  items: items
                      .map((item) => DropdownMenuItem(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(item,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? Colors.white
                                  : Colors.black),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ))
                      .toList(),
                  value: selectedCountry,
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                      selectedCode = countryCodes[value] ?? '+1';
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: fieldHeight,
                    width: fullFieldWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff5E5E66)),
                      color: Theme.of(context).cardColor,
                    ),
                    elevation: 0,
                  ),
                  iconStyleData: IconStyleData(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    iconSize: 18,
                    iconEnabledColor: const Color(0xff5E5E66),
                    iconDisabledColor:
                    Theme.of(context).tabBarTheme.unselectedLabelColor,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    offset: const Offset(0, -1),
                    maxHeight: fieldHeight * 2.2,
                    width: fullFieldWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xff5E5E66)),
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(0),
                      thumbVisibility: MaterialStateProperty.all(false),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 24,
                    padding: EdgeInsets.only(left: 4, right: 21),
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.018),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Text('phone_number'.tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: h * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: SizedBox(
                width: fullFieldWidth,
                height: fieldHeight,
                child: Row(
                  children: [
                    Container(
                      width: w * 0.18,
                      height: fieldHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff5E5E66)),
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Text(selectedCode ?? '+1',
                          style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: h * 0.03),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: fullFieldWidth,
                height: buttonHeight,
                child: OutlinedButton(
                  onPressed: () {
                    {
                      Navigator.pushNamed(context, '/change_pass');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(
                        color: isDark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  child: Text('change_password'.tr(),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ),
            ),
            SizedBox(height: h * 0.15),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: fullFieldWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text('save_info'.tr(),
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: h * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required double width,
    required double height,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          SizedBox(
            width: width,
            height: height,
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildSingleField({
    required String label,
    required double width,
    required double height,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          SizedBox(
            width: width,
            height: height,
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      );
}
