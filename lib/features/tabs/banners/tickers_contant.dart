import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/tickers_provider.dart';import 'package:easy_localization/easy_localization.dart';

import '../../../core/provider/banners_provider.dart';

class TickersContant extends StatefulWidget {
  static const String routeName = "/tickers";
  const TickersContant({super.key});

  @override
  _TickersContantState createState() => _TickersContantState();
}

class _TickersContantState extends State<TickersContant> {
  bool showAddTickerCard = false;
  TextEditingController tickerController = TextEditingController();

  void _toggleAddTickerCard() {
    setState(() {
      showAddTickerCard = !showAddTickerCard;
      tickerController.clear();
    });
  }

  void _addTicker() {
    final text = tickerController.text.trim();
    if (text.isNotEmpty) {
      final provider = Provider.of<TickersProvider>(context, listen: false);
      provider.addTicker(text);

      setState(() {
        tickerController.clear();
        showAddTickerCard = false;
      });
    }
  }

  void _toggleShowHide(int index) {
    final provider = Provider.of<TickersProvider>(context, listen: false);
    provider.setTFolderClicked(true);
    provider.toggleTickerVisibility(index);
  }

  void _deleteTicker(int index) {
    final provider = Provider.of<TickersProvider>(context, listen: false);
    provider.removeTickerAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TickersProvider>(context);
    final myProvider = Provider.of<BannersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            size: 32,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onPressed: () {
            myProvider.setTFolderClicked(false);
          },
        ),
        title: Text(
          "example_tickers".tr(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 24,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onPressed: _toggleAddTickerCard,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          provider.clearTappedTickers();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (showAddTickerCard) _buildAddTickerCard(),

              const SizedBox(height: 16),

              ...(provider.currentTicker?.tickers ?? []).asMap().entries.map((entry) {
                final index = entry.key;
                final text = entry.value;
                final isTapped = provider.tappedTickers.contains(index);
                final isShown = provider.shownTickers.contains(index);

                return GestureDetector(
                  onTap: () => setState(() {
                    provider.toggleTickerTapped(index);
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.drag_indicator, color: Color(0xFFBDBDBD), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Opacity(
                                  opacity: isTapped ? 0.4 : 1.0,
                                  child: Text(
                                    text,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                              ),
                              if (isTapped)
                                GestureDetector(
                                  onTap: () => _toggleShowHide(index),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF666666),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Icon(
                                          isShown ? Icons.remove : Icons.add,
                                          size: 16,
                                          color: const Color(0xFF666666),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isShown ? "hide".tr() : "show".tr(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4F4F4F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (isTapped) ...[
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _deleteTicker(index),
                            child: const Icon(
                              Icons.delete_outline,
                              size: 22,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddTickerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: [
          TextField(
            controller: tickerController,
            decoration: InputDecoration(
              hintText: "ticker_content".tr(),
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
            ),
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showAddTickerCard = false;
                    tickerController.clear();
                  });
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "cancel".tr(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addTicker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "add".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
