import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/stream/drawer/settings/choose_plan_screen.dart';
import 'package:streamore_app/utils/billing_info_dialog.dart';

class BillingTab extends StatefulWidget {
  const BillingTab({super.key});

  @override
  State<BillingTab> createState() => _BillingTabState();
}

class _BillingTabState extends State<BillingTab> {
  bool _isAutoRenewEnabled = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final fontSize = isSmall ? 12.0 : 13.0;
    final cardPadding = EdgeInsets.symmetric(horizontal: isSmall ? 16 : 23);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return SingleChildScrollView(
      padding: cardPadding.copyWith(top: 33, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlanCard(context, fontSize, textColor!),
          _buildProgressCard(
            context: context,
            title: 'storage'.tr(),
            progress: 29 / (5 * 60),
            label: 'minutes_of_hours'.tr(),
            fontSize: fontSize,
            textColor: textColor,
          ),
          _buildProgressCard(
            context: context,
            title: 'streaming_and_recording_hours'.tr(),
            progress: 29 / (20 * 60),
            label: 'minutes_of_hourss'.tr(),
            fontSize: fontSize,
            textColor: textColor,
          ),
          _buildTextCard(
            'payment_method'.tr(),
            Text(
              r'currency_usd$'.tr(),
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                color: textColor,
              ),
            ),


          ),
          _buildActionCard(
            title: 'billing_info'.tr(),
            action: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              ),
              onPressed: () => showEditBillingInfoDialog(context),
              icon: Icon(
                Icons.edit,
                size: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                'edit_info'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildActionCard(
            title: 'invoices'.tr(),
            action: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0,
              ),
              child:  Text('load_invoices'.tr()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
      BuildContext context,
      double fontSize,
      Color textColor,
      ) {
    return _BillingCard(
      title: 'plan'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'you_are_on_the_starter_plan'.tr(),
            style: GoogleFonts.poppins(fontSize: fontSize, color: textColor),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30, 

            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ChoosePlanScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Text(
                'upgrade'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _isAutoRenewEnabled = !_isAutoRenewEnabled;
                }),
                child: Icon(
                  _isAutoRenewEnabled ? Icons.toggle_on : Icons.toggle_off,
                  color: _isAutoRenewEnabled
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'renew_my_subscription_automatically'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'subscription_ends_on_July'.tr(),
            style: GoogleFonts.poppins(
              fontSize: fontSize - 1,
              color: textColor.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required BuildContext context,
    required String title,
    required double progress,
    required String label,
    required double fontSize,
    required Color textColor,
  }) {
    return _BillingCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: fontSize, color: textColor),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).dividerColor.withAlpha(51),
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTextCard(String title, Widget child) {
    return _BillingCard(title: title, child: child);
  }

  Widget _buildActionCard({required String title, required Widget action}) {
    return _BillingCard(title: title, trailing: action);
  }
}

class _BillingCard extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? trailing;

  const _BillingCard({required this.title, this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final titleFontSize = isSmall ? 13.0 : 14.0;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: titleColor,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 6),
            child!,
          ],
        ],
      ),
    );
  }
}
