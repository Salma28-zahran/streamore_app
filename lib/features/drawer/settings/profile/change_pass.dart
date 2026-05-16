import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';

class ChangePass extends StatefulWidget {
  static const String routeName = "/change";

  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final TextEditingController _passwordController = TextEditingController(); // old_password
  final TextEditingController _confirmController = TextEditingController(); // new_password
  final TextEditingController _extraController = TextEditingController();   // confirm_password

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _token; // هنخزن التوكن هنا

  @override
  void initState() {
    super.initState();
    StorageHelper.getToken().then((value) {
      setState(() {
        _token = value;
      });
      print("Token from storage: $value"); // هنا هيتطبع التوكن
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _extraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is ChangePasswordLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }

        if (state is ChangePasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pushReplacementNamed(context, "/signin");
        } else if (state is FailedToChangePasswordState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 55),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 34),
                child: Text(
                  "change".tr(),
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
                label: "old_password".tr(),
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
                label: "new_password".tr(),
                controller: _confirmController,
                obscureText: _obscureConfirm,
                onToggle: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildPasswordField(
                label: "confirm_password".tr(),
                controller: _extraController,
                obscureText: false,
                onToggle: () {},
              ),
              const SizedBox(height: 43),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      final oldPass = _passwordController.text.trim();
                      final newPass = _confirmController.text.trim();
                      final confirmPass = _extraController.text.trim();

                      if (_token == null || _token!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Missing token")),
                        );
                        return;
                      }

                      if (newPass.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "New password must be at least 8 characters")),
                        );
                        return;
                      }

                      if (newPass != confirmPass) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Passwords do not match")),
                        );
                        return;
                      }

                      context.read<AuthCubit>().changePassword(
                        token: _token!,
                        oldPassword: oldPass,
                        newPassword: newPass,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1865E8),
                      minimumSize: const Size(317, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      "change".tr(),
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
                obscureText ? Icons.visibility : Icons.visibility_off,
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
