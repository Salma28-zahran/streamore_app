import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    return SafeArea(
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 33),
            _buildPlanCard(context, fontSize),
            _buildProgressCard(
              title: 'Storage',
              progress: 29 / (5 * 60),
              label: '29 minutes of 5 hours',
              fontSize: fontSize,
            ),
            _buildProgressCard(
              title: 'Streaming and recording hours',
              progress: 29 / (20 * 60),
              label: '29 minutes of 20 hours',
              fontSize: fontSize,
            ),
            _buildTextCard(
              'Payment Method',
              Text(
                'Currency USD\$',
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            _buildActionCard(
              title: 'Billing Info',
              action: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Edit info',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildActionCard(
              title: 'Invoices',
              action: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 0,
                ),
                child: const Text('Load Invoices'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, double fontSize) {
    return _BillingCard(
      title: 'Plan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are on the Starter Plan',
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Text(
                'Upgrade',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  switchTheme: SwitchThemeData(
                    thumbColor: WidgetStateProperty.all(Colors.white),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      return states.contains(WidgetState.selected)
                          ? Theme.of(context).primaryColor
                          : Colors.grey;
                    }),
                    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                child: Transform.scale(
                  scale: 0.66,
                  child: Switch(
                    value: _isAutoRenewEnabled,
                    onChanged: (v) => setState(() => _isAutoRenewEnabled = v),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'Renew my subscription automatically',
                    style: GoogleFonts.poppins(fontSize: fontSize),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Subscription ends on July 30, 2025',
            style: GoogleFonts.poppins(
              fontSize: fontSize - 1,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required double progress,
    required String label,
    required double fontSize,
  }) {
    return _BillingCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).dividerColor.withOpacity(0.2),
            color: Theme.of(context).primaryColor,
          ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(3),
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
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (child != null) ...[const SizedBox(height: 6), child!],
        ],
      ),
    );
  }
}
