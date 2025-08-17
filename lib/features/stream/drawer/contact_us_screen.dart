
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:streamore_app/features/stream/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

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
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (constraints.maxWidth - padding * 2) * 0.47,
                              child: _buildField(
                                label: 'first_name'.tr(),
                                controller: _controllers['first_name'.tr()]!,
                                fontSize: fontSize,
                                labelFont: labelFont,
                                height: fieldHeight,
                                theme: theme,
                              ),
                            ),
                            SizedBox(width: padding * 0.06),
                            SizedBox(
                              width: (constraints.maxWidth - padding * 2) * 0.47,
                              child: _buildField(
                                label: 'last_name'.tr(),
                                controller: _controllers['last_name'.tr()]!,
                                fontSize: fontSize,
                                labelFont: labelFont,
                                height: fieldHeight,
                                theme: theme,
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
                            theme: theme,
                          ),
                        _buildField(
                          label: 'message'.tr(),
                          controller: _controllers['message'.tr()]!,
                          fontSize: fontSize,
                          labelFont: labelFont,
                          height: fieldHeight * 3,
                          maxLines: 6,
                          theme: theme,
                        ),
                        const Spacer(),
                        _buildSendButton(fontSize, theme),
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


  Widget _buildSendButton(double fontSize, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: 343,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 60),
                          const SizedBox(height: 15),
                          Text(
                            "Message Received",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Thank you for reaching out! We’ve received your message and will get back to you as soon as possible.",

                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400

                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Go Home",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();

                            },
                            child:  Text(
                              "Send Another Message",
                              style: TextStyle(
                                color:  Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
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
    required ThemeData theme,
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
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: maxLines == 1 ? height : null,
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                color: theme.textTheme.bodyLarge?.color,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'please_enter $label'.tr();
                }
                if (label == 'email' &&
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return 'enter_a_valid_email_address'.tr();
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: _inputBorder(theme.dividerColor),
                focusedBorder: _inputBorder(theme.primaryColor),
                errorBorder: _inputBorder(Colors.red),
                focusedErrorBorder: _inputBorder(Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}