import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:streamore_app/features/drawer/main_drawer.dart';
import 'package:streamore_app/utils/payment_details_dialog.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class ChoosePlanScreen extends StatefulWidget {
  static const routeName = '/choose-plan';
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  int selectedTabIndex = 0;
  final bool hasNotification = true;

  List<String> getFeatureList(String prefix, int count) {
    return List.generate(count, (i) => tr('$prefix${i + 1}'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(hasNotification: false),

      drawer: MainDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 24),
          _buildTitle(theme),
          const SizedBox(height: 28),
          _buildPlanToggle(context, screenWidth, colorScheme.primary, colorScheme.onSurface),
          const SizedBox(height: 16),
          _buildPlanCard(
            title: 'basic'.tr(),
            priceMain: selectedTabIndex == 0 ? "\$25" : "\$250",
            priceSub: selectedTabIndex == 0 ? "/${'mo'.tr()}" : "/${'yr'.tr()}",
            description: 'basic_description'.tr(),
            features: getFeatureList('basic_feature_', 8),
            planType: 'basic'.tr(),
            priceDisplay: selectedTabIndex == 0 ? '\$25/${'mo'.tr()}' : '\$250/${'yr'.tr()}',
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            title: 'professional'.tr(),
            priceMain: selectedTabIndex == 0 ? "\$50" : "\$500",
            priceSub: selectedTabIndex == 0 ? "/${'mo'.tr()}" : "/${'yr'.tr()}",
            description: 'professional_description'.tr(),
            features: getFeatureList('professional_feature_', 8),
            planType: 'professional'.tr(),
            priceDisplay: selectedTabIndex == 0 ? '\$50/${'mo'.tr()}' : '\$500/${'yr'.tr()}',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget _buildTitle(ThemeData theme) {
    return Center(
      child: Text(
        'choose_your_plan'.tr(),
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildPlanToggle(
    BuildContext context,
    double screenWidth,
    Color primaryColor,
    Color textColor,
  ) {
    final isArabic = context.locale.languageCode == 'ar';

    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: primaryColor),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: (selectedTabIndex == 0)
                  ? (isArabic ? Alignment.centerRight : Alignment.centerLeft)
                  : (isArabic ? Alignment.centerLeft : Alignment.centerRight),
              child: Container(
                width: (screenWidth - 32) / 2,
                height: 42,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildToggleButton('monthly'.tr(), 0, primaryColor, textColor),
              _buildToggleButton('yearly'.tr(), 1, primaryColor, textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    int index,
    Color primaryColor,
    Color textColor,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: selectedTabIndex == index ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String priceMain,
    required String priceSub,
    required String description,
    required List<String> features,
    required String planType,
    required String priceDisplay,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final descriptionColor = theme.textTheme.bodyLarge?.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: lighten(descriptionColor ?? textColor, 0.5),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: priceMain,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              children: [
                TextSpan(
                  text: priceSub,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, color: primaryColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => PaymentDetailsDialog(
                  plan: planType,
                  price: priceDisplay,
                ),
              ),
              child: Text(
                'more_details'.tr(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color lighten(Color color, [double amount = 0.3]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(color, Colors.white, amount) ?? color;
}
