import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// Max encoded image size we will try to upload (matches backend 5 MB).
const int kMaxProductImageBytes = 5 * 1024 * 1024;

class ImagePickFailed implements Exception {
  final bool permissionDenied;
  const ImagePickFailed({this.permissionDenied = false});
}

class ImageTooLargeFailed implements Exception {}

bool _isPermissionDenied(PlatformException e) {
  final code = e.code.toLowerCase();
  return code.contains('denied') ||
      code.contains('access') ||
      code.contains('permission');
}

/// Pick from camera or gallery. Returns null if the user cancelled.
/// Returns an [XFile] which works on both mobile and web.
Future<XFile?> pickProductImage(ImageSource source) async {
  try {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    return xfile;
  } on PlatformException catch (e) {
    throw ImagePickFailed(permissionDenied: _isPermissionDenied(e));
  } catch (_) {
    throw const ImagePickFailed();
  }
}

/// Compress an [XFile] for upload. On web, returns the original bytes
/// unmodified since dart:io compression is not available.
/// Throws [ImageTooLargeFailed] if the result exceeds [kMaxProductImageBytes].
Future<(String path, List<int> bytes)> prepareImageForUpload(XFile xfile) async {
  if (kIsWeb) {
    final bytes = await xfile.readAsBytes();
    if (bytes.length > kMaxProductImageBytes) throw ImageTooLargeFailed();
    return (xfile.path, bytes);
  }
  final file = await compressProductImage(File(xfile.path));
  final bytes = await file.readAsBytes();
  return (file.path, bytes);
}

/// Compress for upload. Falls back to the original file if compression fails.
/// Throws [ImageTooLargeFailed] if the result is still over the limit.
Future<File> compressProductImage(File file) async {
  File result = file;
  try {
    final targetPath = '${file.path}_c.jpg';
    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 75,
      minWidth: 1280,
      minHeight: 1280,
      format: CompressFormat.jpeg,
    );
    if (compressed != null) {
      final compressedFile = File(compressed.path);
      final originalLen = await file.length();
      final compressedLen = await compressedFile.length();
      result = compressedLen <= originalLen ? compressedFile : file;
    }
  } catch (_) {
    result = file;
  }

  if (await result.length() > kMaxProductImageBytes) {
    throw ImageTooLargeFailed();
  }
  return result;
}
