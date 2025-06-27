import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillingTab extends StatelessWidget {
  const BillingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final cardPadding = EdgeInsets.symmetric(horizontal: isSmall ? 16 : 23);
    final fontSize = isSmall ? 12.0 : 13.0;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: cardPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
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
                        style: GoogleFonts.poppins(fontSize: fontSize),
                      ),
                    ),
                    _buildActionCard(
                      title: 'Billing Info',
                      action: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: Color(0xFF007BFF)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Color(0xFF007BFF),
                        ),
                        label: Text(
                          'Edit info',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Color(0xFF007BFF),
                          ),
                        ),
                      ),
                    ),
                    _buildActionCard(
                      title: 'Invoices',
                      action: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF007BFF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Load Invoices',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Color(0xFF007BFF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
              color: Color(0xFF5E5E66),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1865E8),
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
            children: [
              Transform.scale(
                scale: 0.65,
                child: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xff1865E8),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Color(0xffC0C0C0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),

              Flexible(
                child: Text(
                  'Renew my subscription automatically',
                  style: GoogleFonts.poppins(fontSize: fontSize),
                ),
              ),
            ],
          ),
          Text(
            'Subscription ends on July 30, 2025',
            style: GoogleFonts.poppins(
              fontSize: fontSize - 1,
              color: Color(0xFF5E5E66),
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
          Text(label, style: GoogleFonts.poppins(fontSize: fontSize)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: const Color(0xFF5B5CE2),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: const Color(0xFF5E5E66)),
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
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (child != null) ...[const SizedBox(height: 12), child!],
        ],
      ),
    );
  }
}
