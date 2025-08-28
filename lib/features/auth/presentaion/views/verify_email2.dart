import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';
import 'package:streamore_app/widgets/verify_widgets/custombox_verify.dart'
    show CustomBox, CustomboxVerify;

class VerifyEmail2 extends StatefulWidget {
  static const String routeName = "/verify2";

  final String email;

  const VerifyEmail2({super.key, required this.email});

  @override
  State<VerifyEmail2> createState() => _VerifyEmail2State();
}

class _VerifyEmail2State extends State<VerifyEmail2> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;

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
    final activationCode = int.tryParse(code);

    if (activationCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid activation code")),
      );
      return;
    }

    context.read<AuthCubit>().activateAccount(
      email: widget.email,
      activationCode: activationCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is ActivateLoadingState) {
          setState(() => isLoading = true);
        } else if (state is ActivateSuccessState) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacementNamed(context, "/signin");
          });
        } else if (state is FailedToActivateState) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is SendActivateLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sending activation code...")),
          );
        } else if (state is SendActivateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is FailedToSendActivateState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
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
                            text: widget.email,
                          ),
                          TextSpan(
                            text: ' ${'resent_code'.tr()}',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context
                                    .read<AuthCubit>()
                                    .sendActivate(email: widget.email);
                              },
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
                      nextFocus: index < 5 ? _focusNodes[index + 1] : null,
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
          ),
        );
      },
    );
  }
}
