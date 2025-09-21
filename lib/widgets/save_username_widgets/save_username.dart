import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/helpers/storage_helper.dart';

class UserNameWidget extends StatefulWidget{

  const UserNameWidget({super.key , this.style});
  final TextStyle? style;

  @override
  State<UserNameWidget> createState() => _UserNameWidgetState();


}
class _UserNameWidgetState extends State<UserNameWidget> {
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final email = await StorageHelper.getEmail();
    if (email != null && email.contains('@')) {
      setState(() {
        userName = email.split('@')[0];
      });
    }
  }
  Widget build(BuildContext context) {
    return Text(
      userName ?? "No User Found ",
      style:
      widget.style ??
          GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
  }