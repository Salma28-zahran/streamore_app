import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/utils/payment_details_dialog.dart';

class ChoosePlanScreen extends StatefulWidget {
  static const routeName = '/choose-plan';

  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  int selectedTabIndex = 0;
  final bool hasNotification = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    final greyTextColor =
        theme.brightness == Brightness.dark
            ? const Color(0xFFA5A5A5)
            : const Color(0xFFA5A5A5);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          "Streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  color: theme.primaryColorDark,
                  size: 24,
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
          child: Divider(color: theme.dividerColor, thickness: 1, height: 1),
        ),
      ),
      drawer: MainDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 24),
          Center(
            child: Text(
              "Choose Your Plan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
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
                    alignment:
                        selectedTabIndex == 0
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTabIndex = 0),
                        child: Center(
                          child: Text(
                            "Monthly",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color:
                                  selectedTabIndex == 0
                                      ? Colors.white
                                      : primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTabIndex = 1),
                        child: Center(
                          child: Text(
                            "Yearly",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color:
                                  selectedTabIndex == 1
                                      ? Colors.white
                                      : primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PlanCard(
            title: "Basic",
            priceMain: selectedTabIndex == 0 ? "\$25" : "\$250",
            priceSub: selectedTabIndex == 0 ? "/mo" : "/yr",
            description:
                "Dive deeper into streaming, expand your\nreach and brand.",
            features: const [
              "No Streamore logo on your streams",
              "Multistream - 3 destinations",
              "Unlimited streaming",
              "10 on-screen participants",
              "Custom RTMP destinations",
              "Pre-recorded streams - 1 hour",
              "Guest destination",
              "Logos, Overlays, and Backgrounds",
            ],
            cardColor: cardColor,
            textColor: textColor,
            greyTextColor: greyTextColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 16),
          PlanCard(
            title: "Professional",
            priceMain: selectedTabIndex == 0 ? "\$50" : "\$500",
            priceSub: selectedTabIndex == 0 ? "/mo" : "/yr",
            description:
                "Dive deeper into streaming, expand your\nreach and brand.",
            features: const [
              "Full HD (1080P)",
              "Multistream - 8 destinations",
              "Extra camera",
              "12 backstage participants",
              "Download transcripts",
              "4 seats",
              "Pre-recorded streams - 2 hours",
              "Logos, Overlays, and Backgrounds",
            ],
            cardColor: cardColor,
            textColor: textColor,
            greyTextColor: greyTextColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String priceMain;
  final String priceSub;
  final String description;
  final List<String> features;
  final Color cardColor;
  final Color textColor;
  final Color greyTextColor;
  final Color primaryColor;

  const PlanCard({
    super.key,
    required this.title,
    required this.priceMain,
    required this.priceSub,
    required this.description,
    required this.features,
    required this.cardColor,
    required this.textColor,
    required this.greyTextColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.grey.shade300),
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
              color: greyTextColor,
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
                    color: primaryColor,
                    fontWeight: FontWeight.normal,
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => const PaymentDetailsDialog(
                        plan: 'Basic',
                        price: '\$25/mo',
                      ),
                );
              },
              child: Text(
                "More Details",
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
