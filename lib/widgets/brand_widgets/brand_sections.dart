import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:streamore_app/widgets/brand_widgets/section_header.dart';

///——— 1) Logo Section ————————————————————————————————————————————————
class LogoSection extends StatefulWidget {
  const LogoSection({super.key});

  @override
  State<LogoSection> createState() => _LogoSectionState();
}

class _LogoSectionState extends State<LogoSection> {
  bool _isVisible = true;
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = picked);
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
                _buildImageBox(
                  image: _imageFile == null
                      ? Image.asset('assets/images/logo.png', width: 40)
                      : null,
                  file: _imageFile,
                ),
                const SizedBox(width: 10),
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

  Widget _buildImageBox({Image? image, XFile? file}) => Container(
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
    ),
    child: image != null
        ? ClipRRect(borderRadius: BorderRadius.circular(6), child: image)
        : null,
  );
}

///——— 2) Overlay Section ————————————————————————————————————————————————
class OverlaySection extends StatefulWidget {
  const OverlaySection({super.key});

  @override
  State<OverlaySection> createState() => _OverlaySectionState();
}

class _OverlaySectionState extends State<OverlaySection> {
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
          title: 'overlay'.tr(),
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

  Widget _buildImageBox({XFile? file}) => Container(
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
    ),
  );
}

///——— 3) Background Section ————————————————————————————————————————————
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

  Widget _buildImageBox({XFile? file}) => Container(
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
    ),
  );
}
