import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamore_app/core/provider/banners_provider.dart';
import 'package:streamore_app/features/tabs/people/people_card.dart';

class PeopleTab extends StatefulWidget {
  static const String routeName = "/people";
  const PeopleTab({super.key});

  @override
  State<PeopleTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<PeopleTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(

      padding:  EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Share_this_link".tr(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:  Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {}, //  todo copy guest or host profile
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1865E8),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                label: Text(
                  "Copy invite link".tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                icon: Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Color(0xFFC8C8C8),
            thickness: 2,
           endIndent: 3,
            indent: 3,
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, color: Color(0xFF5E5E66)),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${2} person".tr(),
                        style: TextStyle(
                            color: Color(0xFF5E5E66),
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  UserCard(),
                  SizedBox(height: 10),
                  UserCard(),

                ],
              ),
            ),
          ),

        ],

      ),
    );
  }
}
