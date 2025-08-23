import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  static const String routeName = "/signin";

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 55,right: 32),
              child: Text(
                "welcome".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32,right: 32),
              child: Text(
                "back".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 32,right: 40),
              child:
              Container(
                width: double.infinity,
                height: 55,
                color: Color(0xffF3F3F3),
                child:
                TextField(
                  decoration: InputDecoration(
                    labelText: "username_or_email".tr(),
                    hintStyle: GoogleFonts.poppins(
                      color: Color(0xff676767),
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(Icons.person),
                    iconColor: Color(0xff626262),
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
            SizedBox(height: 31),
            Padding(
              padding: const EdgeInsets.only(left: 32,right: 40),
              child: Container(
                width: double.infinity,
                height: 55,
                color: Color(0xffF3F3F3),
                child:
                TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "password".tr(),
                    hintStyle: GoogleFonts.poppins(
                      color: Color(0xff676767),
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                  icon: Icon(
                  _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                    iconColor: Color(0xff626262),

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
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 12,right: 43),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/verify1');
                },
                child: Text(
                  "forgot_password".tr(),
                  style: GoogleFonts.montserrat(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    //decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),


            SizedBox(height: 88),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    {
                      Navigator.pushNamed(context, '/stream');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1865E8),
                    minimumSize: Size(317, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text("login".tr(), style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'create_an_account'.tr(),
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'sign_up'.tr(),
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/signup');
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
