import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/widgets/custombox.dart' show CustomBox;

class VerifyEmail2 extends StatefulWidget {
  static const String routeName = "/verify2";

  const VerifyEmail2({super.key});

  @override
  State<VerifyEmail2> createState() => _VerifyEmail2State();
}

class _VerifyEmail2State extends State<VerifyEmail2> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 99),
              child: Center(
                child: Image.asset("assets/images/verify1.png"),
              ),
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text:
                    'Enter The Confirmation Code We Sent to\n b****32@gmail.com ',
                    style: GoogleFonts.poppins(
                        color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Resent Code',
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
            SizedBox(height: 39),
            Wrap(
              spacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(
                6,
                    (index) => CustomBox(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  nextFocus:
                  index < 5 ? _focusNodes[index + 1] : null,
                ),
              ),
            ),
            SizedBox(height: 37),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isFormFilled
                      ? () {
                    Navigator.pushNamed(context, '/verify3');
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormFilled
                        ? Color(0xff1865E8)
                        : Colors.grey.shade400,
                    minimumSize: Size(138, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    "Next",
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
