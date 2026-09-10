import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/components.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/product_image_io.dart';

/// Snapshot of the image the admin has chosen for create/edit.
class ProductImageSelection {
  /// The picked image as an [XFile], available on both mobile and web.
  final XFile? localXFile;
  final String? existingUrl;
  final bool removed;

  const ProductImageSelection({
    this.localXFile,
    this.existingUrl,
    this.removed = false,
  });

  bool get hasNewImage => localXFile != null;

  bool get hasExisting =>
      existingUrl != null && existingUrl!.isNotEmpty && !removed && localXFile == null;

  bool get shouldClearRemote => removed && localXFile == null;

  bool get hasPreview => localXFile != null || hasExisting;
}

/// Product photo picker used on Add and Edit Product.
///
/// Owns the selected [XFile] so parent rebuilds do not lose it.
class ProductImagePicker extends StatefulWidget {
  final String? existingUrl;
  final bool uploading;
  final Future<XFile?> Function(ImageSource source)? pickImage;

  /// When true, skip decoding local files (widget tests hang on Image.file).
  @visibleForTesting
  static bool skipFileImageDecode = false;

  const ProductImagePicker({
    super.key,
    this.existingUrl,
    this.uploading = false,
    this.pickImage,
  });

  @override
  State<ProductImagePicker> createState() => ProductImagePickerState();
}

class ProductImagePickerState extends State<ProductImagePicker> {
  XFile? _localXFile;
  Uint8List? _localBytes; // preview bytes — works on both web and mobile
  bool _removed = false;
  String? _pickError;

  ProductImageSelection get selection => ProductImageSelection(
        localXFile: _localXFile,
        existingUrl: widget.existingUrl,
        removed: _removed,
      );

  Future<void> pick(ImageSource source) => _pick(source);

  void removeImage() => _remove();

  Future<void> _pick(ImageSource source) async {
    final l = AppLocalizations.of(context)!;
    try {
      final picker = widget.pickImage ??
          (ProductImagePicker.skipFileImageDecode
              ? (_) async => null
              : pickProductImage);
      final xfile = await picker(source);
      if (!mounted) return;
      if (xfile == null) return;
      // Read preview bytes eagerly so Image.memory works on web (Image.file
      // is forbidden there). Skip in widget tests — dart:io I/O hangs the
      // fake-async zone, and skipFileImageDecode already substitutes a placeholder.
      Uint8List? bytes;
      if (!ProductImagePicker.skipFileImageDecode) {
        try {
          bytes = await xfile.readAsBytes();
        } catch (_) {
          bytes = null;
        }
      }
      if (!mounted) return;
      setState(() {
        _localXFile = xfile;
        _localBytes = bytes;
        _removed = false;
        _pickError = null;
      });
    } on ImagePickFailed catch (e) {
      if (!mounted) return;
      setState(() {
        _pickError = e.permissionDenied
            ? l.imagePermissionDenied
            : l.imageSelectFailed;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _pickError = l.imageSelectFailed);
    }
  }

  void _remove() {
    setState(() {
      _localXFile = null;
      _localBytes = null;
      _removed = true;
      _pickError = null;
    });
  }

  Future<void> _change() async {
    final l = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.takePhoto),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null && mounted) await _pick(source);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final sel = selection;
    final hasImage = sel.hasPreview;

    return Column(
      children: [
        Text(
          l.productImage,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: _preview(sel),
                    ),
                  ),
                ),
                if (widget.uploading)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Center(
                        child: SizedBox(
                          key: Key('product-image-uploading'),
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (!hasImage) ...[
          OutlinedButton.icon(
            key: const Key('product-image-take-photo'),
            onPressed: widget.uploading ? null : () => _pick(ImageSource.camera),
            icon: const Icon(Icons.photo_camera_outlined, size: 18),
            label: Text(l.takePhoto),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('product-image-choose-gallery'),
            onPressed: widget.uploading ? null : () => _pick(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined, size: 18),
            label: Text(l.chooseFromGallery),
          ),
        ] else ...[
          OutlinedButton.icon(
            key: const Key('product-image-change'),
            onPressed: widget.uploading ? null : _change,
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: Text(l.changeImage),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            key: const Key('product-image-remove'),
            onPressed: widget.uploading ? null : _remove,
            icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.error),
            label: Text(
              l.removeImage,
              style: const TextStyle(color: AppTheme.error),
            ),
          ),
        ],
        if (_pickError != null) ...[
          const SizedBox(height: 8),
          Text(
            _pickError!,
            key: const Key('product-image-error'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.error, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget _preview(ProductImageSelection sel) {
    if (sel.localXFile != null) {
      final inTest = WidgetsBinding.instance.runtimeType
          .toString()
          .contains('TestWidgetsFlutterBinding');
      if (inTest || ProductImagePicker.skipFileImageDecode) {
        return const ColoredBox(
          key: Key('product-image-local-preview'),
          color: AppTheme.surfaceVariant,
          child: Icon(Icons.image, color: AppTheme.outline),
        );
      }
      // Image.memory works on all platforms (web + mobile).
      // Image.file would crash on Flutter Web.
      final bytes = _localBytes;
      if (bytes != null) {
        return Image.memory(
          bytes,
          key: const Key('product-image-local-preview'),
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          errorBuilder: (_, __, ___) => const _EmptyPhoto(),
        );
      }
      return const ColoredBox(
        key: Key('product-image-local-preview'),
        color: AppTheme.surfaceVariant,
        child: Icon(Icons.image, color: AppTheme.outline),
      );
    }
    if (sel.hasExisting) {
      return ProductNetworkImage(
        url: sel.existingUrl,
        width: 120,
        height: 120,
      );
    }
    return const _EmptyPhoto();
  }
}

class _EmptyPhoto extends StatelessWidget {
  const _EmptyPhoto();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 32, color: AppTheme.outline),
        SizedBox(height: 6),
        Text('Photo', style: TextStyle(fontSize: 12, color: AppTheme.outline)),
      ],
    );
  }
}
