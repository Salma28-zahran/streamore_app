import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';
import 'package:streamore_app/features/auth/presentaion/views/password/verify_pass1.dart';
import 'package:streamore_app/features/auth/presentaion/views/verify_email1.dart';

class SignIn extends StatefulWidget {
  static const String routeName = "/signin";

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscureText = true;

  // Controllers for the inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is LogInSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/stream',
              (route) => false,
            );
          } else if (state is FailedToLogInState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("failed_to_login".tr())));
          } else if (state is ResetPasswordLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sending reset email...")),
            );
          } else if (state is ResetPasswordSuccessState) {
            Navigator.pushNamed(
              context,
              VerifyPass1.routeName,
              arguments: emailController.text,
            );
          } else if (state is FailedToResetPasswordState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      top: 55,
                      right: 32,
                    ),
                    child: Text(
                      "welcome".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Text(
                      "back".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 40),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      color: const Color(0xffF3F3F3),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "email".tr(),
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xff676767),
                            fontSize: 12,
                          ),
                          prefixIcon: const Icon(Icons.person),
                          iconColor: const Color(0xff626262),
                          filled: true,
                          fillColor: const Color(0xffF3F3F3),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 11,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffA8A8A9),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffA8A8A9),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 31),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 40),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      color: const Color(0xffF3F3F3),
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "password".tr(),
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xff676767),
                            fontSize: 12,
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          iconColor: const Color(0xff626262),
                          filled: true,
                          fillColor: const Color(0xffF3F3F3),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 11,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffA8A8A9),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffA8A8A9),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      top: 12,
                      right: 43,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VerifyPass1(),
                          ),
                        );
                      },
                      child: Text(
                        "forgot_password".tr(),
                        style: GoogleFonts.montserrat(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 88),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            state is LogInLoadingState
                                ? null
                                : () {
                                  context.read<AuthCubit>().login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1865E8),
                          minimumSize: const Size(317, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child:
                            state is LogInLoadingState
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  "login".tr(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'create_an_account'.tr(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
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
        },
      ),
    );
  }
}
