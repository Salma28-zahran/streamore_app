import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';
import 'package:streamore_app/widgets/verify_widgets/custombox_verify.dart'
    show CustomBox, CustomboxVerify;

// import الكيوبت + الاستيتس

class VerifyPass2 extends StatefulWidget {
  static const String routeName = "/verify2";

  final String email; // ناخد الإيميل من الصفحة اللي قبلها

  const VerifyPass2({super.key, required this.email});

  @override
  State<VerifyPass2> createState() => _VerifyEmail2State();
}

class _VerifyEmail2State extends State<VerifyPass2> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool get isFormFilled =>
      _controllers.every((controller) => controller.text.trim().isNotEmpty);

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_onInputChanged);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyCode(BuildContext context) {
    final code = _controllers.map((c) => c.text.trim()).join();

    context.read<AuthCubit>().verifyPassCode(
      email: widget.email,
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(),

        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is VerifyPassCodeSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushNamed(
                  context,
                  "/verify3",
                  arguments: widget.email,
                );
              });
            } else if (state is FailedToVerifyPassCodeState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is VerifyPassCodeLoadingState;

            return SafeArea(
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
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text:
                              '${'enter_the_confirmation_code_we_sent_to'.tr()}\n',
                            ),
                            TextSpan(
                              text: widget.email, // نعرض الإيميل الحقيقي
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: '  ${'resent_code'.tr()}',
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 39),
                  Wrap(
                    spacing: 16,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      6,
                          (index) => CustomboxVerify(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        nextFocus:
                        index < 5 ? _focusNodes[index + 1] : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 37),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: isFormFilled && !isLoading
                            ? () => _verifyCode(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormFilled && !isLoading
                              ? const Color(0xff1865E8)
                              : Colors.grey.shade400,
                          minimumSize: const Size(138, 34),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          isLoading ? "Loading..." : "next".tr(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
