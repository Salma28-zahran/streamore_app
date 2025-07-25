// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:streamore_app/my_provider.dart';
// import 'package:provider/provider.dart';

// class BannersContant extends StatefulWidget {
//   static const String routeName = "/ex";
//   const BannersContant({super.key});

//   @override
//   _BannersContantState createState() => _BannersContantState();
// }

// class _BannersContantState extends State<BannersContant> {
//   bool showAddBannerCard = false;
//   TextEditingController bannerController = TextEditingController();
//   List<String> banners = [];
//   Set<int> shownBanners = {};
//   Set<int> tappedBanners = {};
  

//   void _toggleAddBannerCard() {
//     setState(() {
//       showAddBannerCard = !showAddBannerCard;
//       bannerController.clear(); 
//     });
//   }

//   void _addBanner() {
//     final text = bannerController.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         banners.add(text);
//         bannerController.clear();
//         showAddBannerCard = false;
//       });
//     }
//   }

//   void _toggleShowHide(int index) {
//     setState(() {
//       if (shownBanners.contains(index)) {
//         shownBanners.remove(index);
//       } else {
//         shownBanners.add(index);
//       }
//     });
//   }

//   void _deleteBanner(int index) {
//     setState(() {
//       banners.removeAt(index);
//       shownBanners.remove(index);
//       tappedBanners.remove(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//         elevation: 1,
//         leading: IconButton(
//           icon: Icon(Icons.navigate_before, size: 32, color: Theme.of(context).textTheme.bodyLarge?.color),
//           onPressed: () {
//             Provider.of<MyProvider>(context, listen: false).setBFolderClicked(false);

//             print('Navigator pop executed');
//           },
//         ),
//         title: Text(
//           "example_banners".tr(),
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 17,
//             color: Theme.of(context).textTheme.bodyLarge?.color,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add, size: 24, color: Theme.of(context).textTheme.bodyLarge?.color),
//             onPressed: _toggleAddBannerCard,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             if (showAddBannerCard)
//               _buildAddBannerCard(),

//             const SizedBox(height: 16),

//             ...banners.asMap().entries.map((entry) {
//               final index = entry.key;
//               final text = entry.value;
//               final isTapped = tappedBanners.contains(index);
//               final isShown = shownBanners.contains(index);

//               return GestureDetector(
//                 onTap: () => setState(() => tappedBanners.add(index)),
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF0F0F0),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.drag_indicator, color: Color(0xFFBDBDBD), size: 20),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Opacity(
//                                 opacity: isTapped ? 0.4 : 1.0,
//                                 child: Text(
//                                   text,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFF666666),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (isTapped)
//                               GestureDetector(
//                                 onTap: () => _toggleShowHide(index),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       width: 24,
//                                       height: 24,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(color: const Color(0xFF666666), width: 1.5),
//                                       ),
//                                       child: Icon(
//                                         isShown ? Icons.remove : Icons.add,
//                                         size: 16,
//                                         color: const Color(0xFF666666),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       isShown ? "hide".tr() : "show".tr(),
//                                       style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color(0xFF4F4F4F),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                       if (isTapped) ...[
//                         const SizedBox(width: 12),
//                         GestureDetector(
//                           onTap: () => _deleteBanner(index),
//                           child: const Icon(
//                             Icons.delete_outline,
//                             size: 22,
//                             color: Color(0xFFBDBDBD),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddBannerCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Theme.of(context).appBarTheme.backgroundColor,
//         border: Border.all(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey),
//         borderRadius: BorderRadius.circular(3),
//       ),
//       child: Column(
//         children: [
//           TextField(
//             controller: bannerController,
//             decoration: InputDecoration(
//               hintText: "banner_content".tr(),
//               hintStyle: TextStyle(
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? Colors.grey.shade600
//                     : Colors.grey.shade400,
//                 fontWeight: FontWeight.bold,
//               ),
//               filled: true,
//               fillColor: Colors.grey.shade100,
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
//             ),
//             style: TextStyle(
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? Colors.black
//                   : Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     showAddBannerCard = false;
//                     bannerController.clear(); 
//                     print('Example Banners Translation: ${'example_banners'.tr()}');// Clear the text field
//                   });
//                 },
//                 style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                 child: Text(
//                   "Cancel".tr(),
//                   style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: () {
//                   _addBanner();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   "Add".tr(),
//                   style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:streamore_app/my_provider.dart';
import 'package:provider/provider.dart';

class BannersContant extends StatefulWidget {
  static const String routeName = "/ex";
  const BannersContant({super.key});

  @override
  _BannersContantState createState() => _BannersContantState();
}

class _BannersContantState extends State<BannersContant> {
  bool showAddBannerCard = false;
  TextEditingController bannerController = TextEditingController();

  void _toggleAddBannerCard() {
    setState(() {
      showAddBannerCard = !showAddBannerCard;
      bannerController.clear();
    });
  }

  void _addBanner() {
    final text = bannerController.text.trim();
    if (text.isNotEmpty) {
      final myProvider = Provider.of<MyProvider>(context, listen: false);
      myProvider.addBanner(text);  // Add banner content to provider

      setState(() {
        bannerController.clear();
        showAddBannerCard = false;
      });
    }
  }

  void _toggleShowHide(int index) {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.toggleBannerVisibility(index);  // Toggle visibility
  }


  void _deleteBanner(int index) {
  final myProvider = Provider.of<MyProvider>(context, listen: false);
  myProvider.removeBannerAt(index);
}


  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);

    // Ensure that actions are triggered after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger any necessary actions after layout, if required
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.navigate_before, size: 32, color: Theme.of(context).textTheme.bodyLarge?.color),
          onPressed: () {
            myProvider.setBFolderClicked(false);
            print('Navigator pop executed');
          },
        ),
        title: Text(
          "example_banners".tr(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 24, color: Theme.of(context).textTheme.bodyLarge?.color),
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

            // Display banners from the provider
            ...myProvider.banners.asMap().entries.map((entry) {
              final index = entry.key;
              final text = entry.value;
              final isTapped = myProvider.tappedBanners.contains(index);
              final isShown = myProvider.shownBanners.contains(index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    myProvider.toggleBannerTapped(index);  // Toggle tapped state
                  });
                },
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
                      if (isTapped) ...[  // Show delete icon if tapped
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border.all(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: [
          TextField(
            controller: bannerController,
            decoration: InputDecoration(
              hintText: "banner_content".tr(),
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
                    showAddBannerCard = false;
                    bannerController.clear();  // Clear text input
                  });
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "Cancel".tr(),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _addBanner();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Add".tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
