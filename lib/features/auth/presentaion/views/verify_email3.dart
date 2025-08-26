import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';

class VerifyEmail3 extends StatefulWidget {
  static const String routeName = "/verify3";

  final String email;

  const VerifyEmail3({super.key, required this.email});

  @override
  State<VerifyEmail3> createState() => _VerifyEmail3State();
}

class _VerifyEmail3State extends State<VerifyEmail3> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorText;

  void _checkPasswordMatch() {
    setState(() {
      if (_passwordController.text != _confirmController.text) {
        _errorText = "passwords_do_not_match".tr();
      } else {
        _errorText = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordMatch);
    _confirmController.addListener(_checkPasswordMatch);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is ResetPassDoneLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Resetting password...")),
            );
          } else if (state is ResetPassDoneSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushReplacementNamed(context, '/signin');
          } else if (state is FailedToResetPassDoneState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 55),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 34),
                    child: Text(
                      "reset".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 34),
                    child: Text(
                      "password".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 49),
                  _buildPasswordField(
                    label: "new_password".tr(),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    label: "confirm_password".tr(),
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    onToggle: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                  if (_errorText != null)
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 50, top: 8, right: 32),
                      child: Text(
                        _errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 43),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _errorText == null &&
                            _passwordController.text.isNotEmpty &&
                            _confirmController.text.isNotEmpty
                            ? () {
                          context.read<AuthCubit>().resetPasswordDone(
                            email: widget.email,
                            newPassword: _passwordController.text,
                            confirmPassword:
                            _confirmController.text,
                          );
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1865E8),
                          minimumSize: const Size(317, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          "reset".tr(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 40),
      child: Container(
        width: double.infinity,
        height: 55,
        color: const Color(0xffF3F3F3),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xff676767),
              fontSize: 12,
            ),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
              ),
              onPressed: onToggle,
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
    );
  }
}
