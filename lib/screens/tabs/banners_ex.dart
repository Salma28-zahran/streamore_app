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
  int? selectedIndex;
  Set<int> shownBanners = {}; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            onPressed: () {
              setState(() {
                showAddBannerCard = !showAddBannerCard;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (showAddBannerCard) _buildAddBannerCard(),
            const SizedBox(height: 16),
            ...banners.asMap().entries.map((entry) => _buildBannerTile(entry.value, entry.key)).toList(),
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
                onPressed: () {
                  setState(() {
                    showAddBannerCard = false;
                  });
                },
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
                onPressed: () {
                  if (bannerController.text.trim().isNotEmpty) {
                    setState(() {
                      banners.add(bannerController.text.trim());
                      bannerController.clear();
                      showAddBannerCard = false;
                    });
                  }
                },
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

  Widget _buildBannerTile(String text, int index) {
    bool isSelected = selectedIndex == index;
    bool isShown = shownBanners.contains(index);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Opacity(
            opacity: isSelected ? 0.3 : 1.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDragDots(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (isSelected)
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isShown) {
                      shownBanners.remove(index);
                    } else {
                      shownBanners.add(index);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isShown ? Icons.remove_circle_outline : Icons.add_circle_outline,
                        size: 16,
                        color: const Color(0xFF333333),
                      ),
                      const SizedBox(width: 6),
                      Transform.translate(
                        offset: const Offset(0, -2),
                        child: Text(
                          isShown ? "Hide" : "Show",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        if (isSelected)
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  banners.removeAt(index);
                  selectedIndex = null;
                  shownBanners.remove(index); 
                });
              },
              child: const Icon(
                Icons.delete_outline,
                size: 20,
                color: Color(0xFF666666),
              ),
            ),
          ),

        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = isSelected ? null : index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDragDots() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (_) {
        return Row(
          children: [
            _dot(),
            const SizedBox(width: 3),
            _dot(),
          ],
        );
      }),
    );
  }

  Widget _dot() {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: const BoxDecoration(
        color: Color(0xFFBDBDBD),
        shape: BoxShape.circle,
      ),
    );
  }
}
