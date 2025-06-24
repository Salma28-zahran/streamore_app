import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatelessWidget {
  static const String routeName = "/signup";

  const SignUp({super.key});

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
                "Create an ",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 36),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                "account",
                style: GoogleFonts.poppins(
                 fontWeight: FontWeight.bold, fontSize: 36
                ),),),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 172,
                    height: 55,
                    child:
                    TextField(
                      decoration: InputDecoration(
                        labelText: "First Name",
                        hintStyle: TextStyle(color: Color(0xff676767), fontSize: 12),

                        prefixIcon: Icon(Icons.person),
                        iconColor: Color(0xff676767),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        focusColor: Color(0xffF3F3F3),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 172,
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        hintStyle: TextStyle(color: Color(0xff676767), fontSize: 12),
                        prefixIcon: Icon(Icons.person),
                        iconColor: Color(0xff676767),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        focusColor: Color(0xffF3F3F3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child:
              TextField(
                decoration: InputDecoration(
                  labelText: " Email",
                  hintStyle: TextStyle(
                    color: Color(0xff676767),
                    fontSize: 12,
                  ),

                  prefixIcon: Icon(Icons.person),
                  iconColor: Color(0xff676767),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  focusColor: Color(0xffF3F3F3),
                ),
              ),
            ),
            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: " Password",
                  hintStyle: TextStyle(
                    color: Color(0xff676767),
                    fontSize: 12,
                  ),

                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.remove_red_eye_outlined),

                  iconColor: Color(0xff676767),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  focusColor: Color(0xffF3F3F3),
                ),
              ),
            ),
            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child:
              TextField(
                decoration: InputDecoration(
                  labelText: " Confirm Password",
                  hintStyle: TextStyle(
                    color: Color(0xff676767),
                    fontSize: 12,
                  ),

                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.remove_red_eye_outlined),

                  iconColor: Color(0xff676767),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  focusColor: Color(0xffF3F3F3),
                ),
              ),
            ),
            SizedBox(height: 15),



            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'By clicking the ',
                    ),
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextSpan(
                      text: ' button, you agree\n',
                    ),
                    TextSpan(
                      text: 'to the public offer',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 53),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1865E8),
                    minimumSize: Size(317, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Create Account",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'I Already Have an Account ',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style:
                        TextStyle(color: Colors.blue,
                            fontSize: 16, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/signin');
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),








          ],

        ),
      ),
    );
  }
}
