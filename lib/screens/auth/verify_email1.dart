import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmail1 extends StatelessWidget {
  static const String routeName = "/verify1";

  const VerifyEmail1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 99),
              child: SizedBox(
                width: 310,
                height: 55,
                child: Image.asset(
                  "assets/images/app_name.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 28,),
            Text("please_verify_your_email".tr(),
              style:GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ) ,),
            SizedBox(height: 5,),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: "${'enter_your_email_address_to_receive_a'.tr()}\n"),
                  TextSpan(text: "verification_code".tr()),
                ],
              ),
            ),


            SizedBox(height: 46),
            Padding(
              padding: const EdgeInsets.only(left: 32,right: 30),
              child:
              Container(
                width: 378,
                height: 55,
                color: Color(0xffF3F3F3),
                child:
                TextField(
                  decoration: InputDecoration(
                    labelText: "email".tr(),
                    hintStyle: GoogleFonts.poppins(
                      color: Color(0xff676767),
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: Color(0xffF3F3F3),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 11,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xffA8A8A9),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xffA8A8A9),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 56,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    {
                      Navigator.pushNamed(context, '/verify2');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1865E8),
                    minimumSize: Size(138, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text("send_code".tr(),
                      style: GoogleFonts.poppins(
                          color: Colors.white,fontSize: 12,fontWeight: FontWeight.w700)),
                ),
              ],
            ),

            SizedBox(height: 132,),
            Text("question_email_us".tr(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:Color(0XFF000000),
              ),),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text(
                "support@Streamore.io",
                style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  //decoration: TextDecoration.underline,
                ),
              ),
            ),










          ],
        ),
      ),

    );
  }
}
