import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme.dart';

/// Shared helper — shows a bottom sheet to pick a prescription from
/// gallery/camera (files), then shows a confirmation snackbar.
/// ponytail: upload-to-server logic goes in the `onFilePicked` callback
/// once the backend API is ready.
Future<void> pickPrescription(
  BuildContext context, {
  void Function(PlatformFile file)? onFilePicked,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _PrescriptionPickerSheet(onFilePicked: onFilePicked),
  );
}

class _PrescriptionPickerSheet extends StatefulWidget {
  final void Function(PlatformFile file)? onFilePicked;
  const _PrescriptionPickerSheet({this.onFilePicked});

  @override
  State<_PrescriptionPickerSheet> createState() => _PrescriptionPickerSheetState();
}

class _PrescriptionPickerSheetState extends State<_PrescriptionPickerSheet> {
  bool _picking = false;

  Future<void> _pick(FileType type, {bool camera = false}) async {
    setState(() => _picking = true);
    try {
      if (camera) {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (!mounted) return;
        if (image != null) {
          final size = await image.length();
          if (!mounted) return;
          final file = PlatformFile(name: image.name, path: image.path, size: size);
          widget.onFilePicked?.call(file);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Prescription "${file.name}" uploaded')),
          );
        } else {
          Navigator.pop(context);
        }
        return;
      }
      final result = await FilePicker.platform.pickFiles(
        type: type == FileType.image ? FileType.image : FileType.custom,
        allowedExtensions: type == FileType.custom ? ['pdf'] : null,
        allowMultiple: false,
      );
      if (!mounted) return;
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        widget.onFilePicked?.call(file);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription "${file.name}" uploaded'),
            backgroundColor: AppTheme.successText,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          const Text('Upload Prescription',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.text)),
          const SizedBox(height: 6),
          const Text('Share a clear photo or PDF of your prescription',
              style: TextStyle(fontSize: 13, color: AppTheme.mutedText), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          if (_picking)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          else ...[
            _OptionTile(
              icon: Icons.camera_alt_outlined,
              title: 'Take a Photo',
              subtitle: 'Use your camera to capture the prescription',
              onTap: () => _pick(FileType.image, camera: true),
            ),
            const SizedBox(height: 12),
            _OptionTile(
              icon: Icons.photo_library_outlined,
              title: 'Choose from Gallery',
              subtitle: 'Select an existing photo from your phone',
              onTap: () => _pick(FileType.image),
            ),
            const SizedBox(height: 12),
            _OptionTile(
              icon: Icons.picture_as_pdf_outlined,
              title: 'Upload PDF',
              subtitle: 'Pick a PDF prescription file',
              onTap: () => _pick(FileType.custom),
            ),
          ],
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 12, color: AppTheme.mutedText),
              SizedBox(width: 4),
              Text('Your data is encrypted and 100% private',
                  style: TextStyle(fontSize: 11, color: AppTheme.mutedText)),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _OptionTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.mutedText),
          ],
        ),
      ),
    );
  }
}
