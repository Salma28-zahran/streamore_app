import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/my_provider.dart';

class BannersContant extends StatefulWidget {
  static const String routeName = "/ex";
  const BannersContant({super.key});

  @override
  _BannersContantState createState() => _BannersContantState();
}

class _BannersContantState extends State<BannersContant> {
  bool showAddBannerCard = false;
  TextEditingController bannerController = TextEditingController();
  List<String> banners = [];
  Set<int> shownBanners = {};
  Set<int> tappedBanners = {};

  void _toggleAddBannerCard() {
    setState(() {
      showAddBannerCard = !showAddBannerCard;
      bannerController.clear(); 
    });
  }

  void _addBanner() {
    final text = bannerController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        banners.add(text);
        bannerController.clear();
        showAddBannerCard = false;
      });
    }
  }

  void _toggleShowHide(int index) {
    setState(() {
      if (shownBanners.contains(index)) {
        shownBanners.remove(index);
      } else {
        shownBanners.add(index);
      }
    });
  }

  void _deleteBanner(int index) {
    setState(() {
      banners.removeAt(index);
      shownBanners.remove(index);
      tappedBanners.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before, size: 32, color: Color(0xFF666666)),
          onPressed: () {
            Provider.of<MyProvider>(context, listen: false).setBFolderClicked(false);
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Example Banners",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 24, color: Color(0xFF666666)),
            onPressed: _toggleAddBannerCard,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (showAddBannerCard)
              _buildAddBannerCard(),

            const SizedBox(height: 16),

            ...banners.asMap().entries.map((entry) {
              final index = entry.key;
              final text = entry.value;
              final isTapped = tappedBanners.contains(index);
              final isShown = shownBanners.contains(index);

              return GestureDetector(
                onTap: () => setState(() => tappedBanners.add(index)),
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
                                        border: Border.all(color: const Color(0xFF666666), width: 1.5),
                                      ),
                                      child: Icon(
                                        isShown ? Icons.remove : Icons.add,
                                        size: 16,
                                        color: const Color(0xFF666666),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isShown ? "Hide" : "Show",
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
                          onTap: () => _deleteBanner(index),
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
    );
  }

  Widget _buildAddBannerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: bannerController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Banner Content",
                hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleAddBannerCard,
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addBanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D6EFD),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
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