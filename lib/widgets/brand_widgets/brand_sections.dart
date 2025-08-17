import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/background-overlay-logo_provider.dart';
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
      Provider.of<BackgroundOverlayLogoProvider>(context, listen: false).setLogoImage(picked);
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
                Consumer<BackgroundOverlayLogoProvider>(
                  builder: (context, provider, child) {
                    return _buildImageBox(
                      image:
                          provider.logoImageFile == null
                              ? Image.asset('assets/images/logo.png', width: 40)
                              : null,
                      file: provider.logoImageFile,
                      provider: provider,
                      isDefault: provider.logoImageFile == null,
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

  Widget _buildImageBox({
    Image? image,
    XFile? file,
    BackgroundOverlayLogoProvider? provider,
    bool isDefault = false,
  }) {
    bool isSelected =
        (provider?.logoImageFile == file) ||
        (isDefault && provider?.logoImageFile == null);

    Widget content;

    if (file != null || isDefault) {
      content = Container(
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
                  : image != null
                  ? DecorationImage(image: image.image, fit: BoxFit.cover)
                  : null,
          border:
              isSelected
                  ? Border.all(color: Colors.blue, width: 3)
                  : Border.all(color: Colors.transparent),
        ),
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
        final provider = Provider.of<BackgroundOverlayLogoProvider>(context, listen: false);
        if (provider.logoImageFile == null && !isDefault) {
          provider.showDefaultLogo();
        } else {
          provider.toggleLogoVisibility();
        }
      },
      child: content,
    );
  }

  Widget _buildAddBox({required VoidCallback onTap}) {
    return GestureDetector(
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
}

///— Overlay Section ————————————————————————————————————————————————
class OverlaySection extends StatefulWidget {
  const OverlaySection({super.key});

  @override
  _OverlaySectionState createState() => _OverlaySectionState();
}

class _OverlaySectionState extends State<OverlaySection> {
  bool _isVisible = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      context.read<BackgroundOverlayLogoProvider>().addOverlayImage(pickedFile);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No image selected')));
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
            child: Consumer<BackgroundOverlayLogoProvider>(
              builder: (context, provider, child) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ..._buildImageList(provider),
                    _buildAddImageBox(onTap: _pickImage),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  List<Widget> _buildImageList(BackgroundOverlayLogoProvider provider) {
    int remainingSlots = 7 - provider.overlayImages.length;

    List<Widget> imageBoxes =
        provider.overlayImages
            .map(
              (file) => _buildImageBox(overlayImage: file, provider: provider),
            )
            .toList();

    imageBoxes.addAll(
      List.generate(remainingSlots.clamp(0, 7), (_) => _buildImageBox()),
    );

    return imageBoxes;
  }

  Widget _buildImageBox({XFile? overlayImage, BackgroundOverlayLogoProvider? provider}) {
    bool isSelected = provider?.selectedOverlayImage == overlayImage;

    return GestureDetector(
      onTap: () {
        if (overlayImage != null) {
          provider?.showOverlayImage(overlayImage);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[300],
          image:
              overlayImage != null
                  ? DecorationImage(
                    image: FileImage(File(overlayImage.path)),
                    fit: BoxFit.cover,
                  )
                  : null,
          border:
              overlayImage != null
                  ? Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 3,
                  )
                  : Border.all(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildAddImageBox({required VoidCallback onTap}) {
    return GestureDetector(
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
}

///— Background Section ————————————————————————————————————————————
class BackgroundSection extends StatefulWidget {
  const BackgroundSection({super.key});

  @override
  State<BackgroundSection> createState() => _BackgroundSectionState();
}

class _BackgroundSectionState extends State<BackgroundSection> {
  bool _isVisible = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      context.read<BackgroundOverlayLogoProvider>().addBackgroundImage(pickedFile);
    }
  }

  List<Widget> _buildImageList(BackgroundOverlayLogoProvider provider) {
    int remainingSlots = 7 - provider.backgroundImages.length;

    List<Widget> imageBoxes =
        provider.backgroundImages
            .map((file) => _buildImageBox(file: file, provider: provider))
            .toList();

    imageBoxes.addAll(
      List.generate(remainingSlots.clamp(0, 7), (_) => _buildImageBox()),
    );

    return imageBoxes;
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
            child: Consumer<BackgroundOverlayLogoProvider>(
              builder: (context, provider, child) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ..._buildImageList(provider),
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

  Widget _buildImageBox({XFile? file, BackgroundOverlayLogoProvider? provider}) {
    bool isSelected = provider?.selectedBackgroundImage == file;

    return GestureDetector(
      onTap: () {
        if (file != null) {
          provider?.showBackgroundImage(file);
          print("Background image selected: ${file.path}");
        }
      },
      child: Container(
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
          border:
              file != null
                  ? Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 3,
                  )
                  : Border.all(color: Colors.transparent),
        ),
      ),
    );
  }
}
