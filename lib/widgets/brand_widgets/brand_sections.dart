// import 'dart:io';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../my_provider.dart';
// import 'package:streamore_app/widgets/brand_widgets/section_header.dart';

// class LogoSection extends StatefulWidget {
//   const LogoSection({super.key});

//   @override
//   State<LogoSection> createState() => _LogoSectionState();
// }

// class _LogoSectionState extends State<LogoSection> {
//   bool _isVisible = true;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       Provider.of<MyProvider>(context, listen: false).setLogoImage(picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SectionHeader(
//           title: 'logo'.tr(),
//           isVisible: _isVisible,
//           onToggle: () => setState(() => _isVisible = !_isVisible),
//         ),
//         if (_isVisible)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Row(
//               children: [
//                 Consumer<MyProvider>(
//                   builder: (context, provider, child) {
//                     return _buildImageBox(
//                       image:
//                           provider.logoImageFile == null
//                               ? Image.asset('assets/images/logo.png', width: 40)
//                               : null,
//                       file: provider.logoImageFile,
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 _buildAddBox(onTap: _pickImage),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildImageBox({Image? image, XFile? file}) {
//     Widget content;

//     if (file != null) {
//       content = Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(6),
//           color: Colors.grey[300],
//           image: DecorationImage(
//             image: FileImage(File(file.path)),
//             fit: BoxFit.cover,
//           ),
//         ),
//       );
//     } else if (image != null) {
//       content = ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: SizedBox(width: 60, height: 60, child: image),
//       );
//     } else {
//       content = Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(6),
//           color: Colors.grey[300],
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: () {
//         final provider = Provider.of<MyProvider>(context, listen: false);
//         if (provider.logoImageFile == null) {
//           provider.showDefaultLogo(); // <-- Show default logo
//         } else {
//           provider.toggleLogoVisibility();
//         }
//       },

//       child: content,
//     );
//   }

//   Widget _buildAddBox({required VoidCallback onTap}) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: Colors.grey[300],
//       ),
//       child: const Icon(Icons.add),
//     ),
//   );
// }

///——— 2) Overlay Section ————————————————————————————————————————————————
// class OverlaySection extends StatefulWidget {
//   const OverlaySection({super.key});

//   @override
//   State<OverlaySection> createState() => _OverlaySectionState();
// }

// class _OverlaySectionState extends State<OverlaySection> {
//   bool _isVisible = true;
//   final List<XFile> _images = [];

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) setState(() => _images.add(picked));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SectionHeader(
//           title: 'overlay'.tr(),
//           isVisible: _isVisible,
//           onToggle: () => setState(() => _isVisible = !_isVisible),
//         ),
//         if (_isVisible)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: [
//                 ..._images
//                     .map((f) => _buildImageBox(file: f))
//                     .toList(growable: false),
//                 ...List.generate(
//                   7 - _images.length.clamp(0, 7),
//                   (_) => _buildImageBox(),
//                 ),
//                 _buildAddBox(onTap: _pickImage),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildAddBox({required VoidCallback onTap}) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: Colors.grey[300],
//       ),
//       child: const Icon(Icons.add),
//     ),
//   );

//   Widget _buildImageBox({XFile? file}) {
//     Widget container = Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: Colors.grey[300],
//         image:
//             file != null
//                 ? DecorationImage(
//                   image: FileImage(File(file.path)),
//                   fit: BoxFit.cover,
//                 )
//                 : null,
//       ),
//     );

//     return GestureDetector(
//       onTap: () {
//         if (file != null) {
//           Provider.of<MyProvider>(
//             context,
//             listen: false,
//           ).showOverlayImage(file);
//         }
//       },
//       child: container,
//     );
//   }
// }


import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../my_provider.dart';
import 'package:streamore_app/widgets/brand_widgets/section_header.dart';

///— Logo Section ————————————————————————————————————————————
class LogoSection extends StatefulWidget {
  const LogoSection({super.key});

  @override
  State<LogoSection> createState() => _LogoSectionState();
}

class _LogoSectionState extends State<LogoSection> {
  bool _isVisible = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      Provider.of<MyProvider>(context, listen: false).setLogoImage(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'logo'.tr(),
          isVisible: _isVisible,
          onToggle: () => setState(() => _isVisible = !_isVisible),
        ),
        if (_isVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Consumer<MyProvider>(
                  builder: (context, provider, child) {
                    return _buildImageBox(
                      image: provider.logoImageFile == null
                          ? Image.asset('assets/images/logo.png', width: 40)
                          : null,
                      file: provider.logoImageFile,
                    );
                  },
                ),
                const SizedBox(width: 10),
                _buildAddBox(onTap: _pickImage),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImageBox({Image? image, XFile? file}) {
    Widget content;

    if (file != null) {
      content = Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[300],
          image: DecorationImage(
            image: FileImage(File(file.path)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (image != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(width: 60, height: 60, child: image),
      );
    } else {
      content = Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[300],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        final provider = Provider.of<MyProvider>(context, listen: false);
        if (provider.logoImageFile == null) {
          provider.showDefaultLogo(); // <-- Show default logo
        } else {
          provider.toggleLogoVisibility();
        }
      },
      child: content,
    );
  }

  Widget _buildAddBox({required VoidCallback onTap}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[300],
      ),
      child: const Icon(Icons.add),
    ),
  );
}

///— Overlay Section ————————————————————————————————————————————————
class OverlaySection extends StatefulWidget {
  const OverlaySection({super.key});

  @override
  State<OverlaySection> createState() => _OverlaySectionState();
}

class _OverlaySectionState extends State<OverlaySection> {
  bool _isVisible = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      Provider.of<MyProvider>(context, listen: false).addOverlayImage(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'overlay'.tr(),
          isVisible: _isVisible,
          onToggle: () => setState(() => _isVisible = !_isVisible),
        ),
        if (_isVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Consumer<MyProvider>(
              builder: (context, provider, child) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...provider.overlayImages
                        .map((f) => _buildImageBox(file: f, provider: provider))
                        .toList(growable: false),

                    ...List.generate(
                      7 - provider.overlayImages.length.clamp(0, 7),
                      (_) => _buildImageBox(),
                    ),
                    _buildAddBox(onTap: _pickImage),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddBox({required VoidCallback onTap}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[300],
      ),
      child: const Icon(Icons.add),
    ),
  );

  Widget _buildImageBox({XFile? file, MyProvider? provider}) {
    bool isSelected = provider?.selectedOverlayImage == file;
    
    Widget container = Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[300],
        image: file != null
            ? DecorationImage(
                image: FileImage(File(file.path)),
                fit: BoxFit.cover,
              )
            : null,
        border: isSelected
            ? Border.all(
                color: Colors.transparent, 
                width: 3,
              )
            : Border.all(
                color: Colors.transparent, 
              ),
      ),
    );

    return GestureDetector(
      onTap: () {
        if (file != null) {
          provider?.showOverlayImage(file);
        }
      },
      child: container,
    );
  }
}


///— Background Section ————————————————————————————————————————————
class BackgroundSection extends StatefulWidget {
  const BackgroundSection({super.key});

  @override
  State<BackgroundSection> createState() => _BackgroundSectionState();
}

class _BackgroundSectionState extends State<BackgroundSection> {
  bool _isVisible = true;
  final List<XFile> _images = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _images.add(picked));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'background'.tr(),
          isVisible: _isVisible,
          onToggle: () => setState(() => _isVisible = !_isVisible),
        ),
        if (_isVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ..._images
                    .map((f) => _buildImageBox(file: f))
                    .toList(growable: false),
                // Fill empty spaces with placeholders
                ...List.generate(
                  7 - _images.length.clamp(0, 7),
                  (_) => _buildImageBox(),
                ),
                _buildAddBox(onTap: _pickImage),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAddBox({required VoidCallback onTap}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[300],
      ),
      child: const Icon(Icons.add),
    ),
  );

  Widget _buildImageBox({XFile? file}) {
    Widget container = Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[300],
        image:
            file != null
                ? DecorationImage(
                    image: FileImage(File(file.path)),
                    fit: BoxFit.cover,
                  )
                : null,
      ),
    );

    return GestureDetector(
      onTap: () {
        if (file != null) {
          print('Background image tapped: ${file.path}');
        }
      },
      child: container,
    );
  }
}
