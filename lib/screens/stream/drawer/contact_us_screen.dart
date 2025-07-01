import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

class ContactUsScreen extends StatefulWidget {
  static const String routeName = '/contact-us';

  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _controllers = {
    'first_name'.tr(): TextEditingController(),
    'last_name'.tr(): TextEditingController(),
    'email'.tr(): TextEditingController(),
    'subject'.tr(): TextEditingController(),
    'message'.tr(): TextEditingController(),
  };

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    const hasNotification = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(),
      appBar: _buildAppBar(media, hasNotification),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth * 0.04;
            final fieldHeight = constraints.maxHeight * 0.04;
            final fontSize = constraints.maxWidth * 0.035;
            final labelFont = constraints.maxWidth * 0.035;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.03),
                        Text(
                          'contact_us'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.048,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:
                                  (constraints.maxWidth - padding * 2) * 0.47,
                              child: _buildField(
                                label: 'first_name'.tr(),
                                controller: _controllers['first_name'.tr()]!,
                                fontSize: fontSize,
                                labelFont: labelFont,
                                height: fieldHeight,
                              ),
                            ),
                            SizedBox(width: padding * 0.06),
                            SizedBox(
                              width:
                                  (constraints.maxWidth - padding * 2) * 0.47,
                              child: _buildField(
                                label: 'last_name'.tr(),
                                controller: _controllers['last_name'.tr()]!,
                                fontSize: fontSize,
                                labelFont: labelFont,
                                height: fieldHeight,
                              ),
                            ),
                          ],
                        ),

                        for (final label in ['email'.tr(), 'subject'.tr()])
                          _buildField(
                            label: label,
                            controller: _controllers[label]!,
                            fontSize: fontSize,
                            labelFont: labelFont,
                            height: fieldHeight,
                          ),
                        _buildField(
                          label: 'message'.tr(),
                          controller: _controllers['message'.tr()]!,
                          fontSize: fontSize,
                          labelFont: labelFont,
                          height: fieldHeight * 3,
                          maxLines: 6,
                        ),
                        const Spacer(),
                        _buildSendButton(fontSize),
                        SizedBox(height: constraints.maxHeight * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(Size media, bool hasNotification) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Streamore",
        style: GoogleFonts.poppins(
          fontSize: media.width * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: media.width * 0.03),
          child: Stack(
            children: [
              Icon(
                FontAwesomeIcons.bell,
                size: media.width * 0.055,
                color: Color(0xff1865E8),
              ),
              if (hasNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildSendButton(double fontSize) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar( SnackBar(content: Text('message_sent'.tr())));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff1865E8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          'send_message'.tr(),
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required double fontSize,
    required double labelFont,
    required double height,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: labelFont,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: maxLines == 1 ? height : null,
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              style: GoogleFonts.poppins(fontSize: fontSize),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'please_enter $label'.tr();
                }
                if (label == 'email' &&
                    !RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$',
                    ).hasMatch(value)) {
                  return 'enter_a_valid_email_address'.tr();
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: _inputBorder(),
                focusedBorder: _inputBorder(color: const Color(0xff1865E8)),
                errorBorder: _inputBorder(color: Colors.red),
                focusedErrorBorder: _inputBorder(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder({Color color = const Color(0xFF5E5E66)}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
