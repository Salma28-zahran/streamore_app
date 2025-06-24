import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatelessWidget {
  static const String routeName = "/signin";

  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 55),
              child: Text(
                "Welcome",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                "Back!",
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
                    labelText: "Username or Email",
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
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintStyle: GoogleFonts.poppins(
                      color: Color(0xff676767),
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(FontAwesomeIcons.eye),
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
              padding: const EdgeInsets.only(left: 32, top: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/verify1');
                },
                child: Text(
                  "Forgot Password?",
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
                  child: Text("Login", style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Create an account? ',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
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
