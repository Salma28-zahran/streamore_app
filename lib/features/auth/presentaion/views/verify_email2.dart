import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/widgets/verify_widgets/custombox_verify.dart' show CustomBox, CustomboxVerify;

class VerifyEmail2 extends StatefulWidget {
  static const String routeName = "/verify2";

  final String email; // لازم يوصلك من صفحة الـ Register

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

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text.trim()).join();

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/activate/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "activation_code": code,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account activated successfully!")),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, "/signin");
        });
      } else {
        final errorMessage =
            responseBody['message'] ?? responseBody['error'] ?? "Unknown error";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

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
                        text: widget.email, // الإيميل اللي جاي من register
                      ),
                      TextSpan(
                        text: ' ${'resent_code'.tr()}',
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
                  onPressed: isFormFilled && !isLoading ? _verifyCode : null,
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
  }
}
