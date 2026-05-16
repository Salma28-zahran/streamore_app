import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/helpers/storage_helper.dart';

class UserNameWidget extends StatefulWidget {
  const UserNameWidget({super.key,
    this.style,});
  final TextStyle? style;



  @override
  State<UserNameWidget> createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> {
  String? currentEmail;
  List<String> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }


  Future<void> loadAccounts() async {
    currentEmail = await StorageHelper.getEmail();
    accounts = await StorageHelper.getAccounts();

    if (mounted) {
      setState(() {});
    }
  }

  String get userName {
    if (currentEmail == null) return "No User Found";
    return currentEmail!.split('@')[0];
  }

  Future<void> switchAccount(String email) async {
    await StorageHelper.setCurrentEmail(email);

    setState(() {
      currentEmail = email;
    });

    /// هنا بعدين هنحط logic الـ login
  }

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return Text(
        userName,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentEmail,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: accounts.map((email) {
          return DropdownMenuItem(
            value: email,
            child: Text(
              email.split('@')[0],
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            switchAccount(value);
          }
        },
      ),
    );
  }
}