import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';
import 'package:streamore_app/features/auth/presentaion/views/verify_email2.dart';

class SignUp extends StatefulWidget {
  static const String routeName = "/signup";

  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyEmail2(email: emailController.text.trim()),
            ),
          );

        } else if (state is FailedToRegisterState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
            padding: EdgeInsets.only(
        ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32, top: 55),
                    child: Text(
                      "create_an ".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      "account".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "email".tr(),
                        hintStyle: const TextStyle(
                          color: Color(0xff676767),
                          fontSize: 12,
                        ),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        focusColor: const Color(0xffF3F3F3),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email must not be empty";
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return "Please enter a valid email (e.g. name@example.com)";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "password".tr(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "confirm_password".tr(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'by_clicking_the'.tr(),
                          ),
                          TextSpan(
                            text: 'register'.tr(),
                            style: const TextStyle(color: Colors.blue),
                          ),
                          TextSpan(
                            text: 'button,_you_agree\n'.tr(),
                          ),
                          TextSpan(
                            text: 'to_the_public_offer'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 53),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final confirmPassword =
                            confirmPasswordController.text.trim();

                            if (email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("All fields are required"),
                                ),
                              );
                              return;
                            }

                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter a valid email (e.g. name@example.com)",
                                  ),
                                ),
                              );
                              return;
                            }

                            if (password.length < 8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Password must be at least 8 characters"),
                                ),
                              );
                              return;
                            }

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                  Text("Passwords do not match"),
                                ),
                              );
                              return;
                            }

                            // استدعاء register من النسخة اللي فوق
                            context.read<AuthCubit>().register(
                              email: email,
                              password: password,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1865E8),
                          minimumSize: const Size(317, 55),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          state is RegisterLoadingState
                              ? "loading...."
                              : "create_account".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
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
                          text: 'i_already_have_an_account '.tr(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'login'.tr(),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/signin');
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
          ),
        ));
      },
    );
  }

  Widget _textFieldItem({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    IconData? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (input) {
        if (controller.text.isEmpty) {
          return "$labelText must not be empty";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintStyle: const TextStyle(
          color: Color(0xff676767),
          fontSize: 12,
        ),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        iconColor: const Color(0xff676767),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        focusColor: const Color(0xffF3F3F3),
      ),
    );
  }
}
