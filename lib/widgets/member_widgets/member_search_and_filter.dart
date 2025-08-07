import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/my_provider.dart';

class MemberSearchAndFilter extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;
  final List<String> roles;

  const MemberSearchAndFilter({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final myprovider = Provider.of<MyProvider>(context);
    final isDark = myprovider.themeMode == ThemeMode.dark;

    return Row(
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
            items: roles.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Padding(
                  padding: EdgeInsets.only(left: mq.width * 0.02),
                  child: Text(
                    item.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: mq.width * 0.03,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
            value: selectedValue,
            onChanged: onChanged,
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
              iconDisabledColor:
              Theme.of(context).tabBarTheme.unselectedLabelColor,
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
    );
  }
}
