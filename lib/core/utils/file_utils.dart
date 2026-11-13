import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  static const String _screenshotsDirectory = 'screenshots';

  /// Returns the size of an image file in bytes.
  static Future<int> getFileSize(String imagePath) async {
    final imageFile = File(imagePath);

    if (!await imageFile.exists()) return 0;

    return imageFile.length();
  }

  /// Returns the app-private screenshots directory.
  static Future<Directory> getScreenshotsDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final screenshotsDirectory = Directory(
      path.join(appDirectory.path, _screenshotsDirectory),
    );

    if (!await screenshotsDirectory.exists()) {
      await screenshotsDirectory.create(recursive: true);
    }

    return screenshotsDirectory;
  }

  /// Generates SHA-256 hash for an image file.
  static Future<String> generateImageHash(String imagePath) async {
    final imageFile = File(imagePath);

    if (!await imageFile.exists()) {
      throw FileSystemException('Image file does not exist.', imagePath);
    }

    final imageBytes = await imageFile.readAsBytes();

    return sha256.convert(imageBytes).toString();
  }

  /// Copies an image into app-private storage.
  static Future<String> copyImageToAppStorage({
    required String sourcePath,
    required String imageHash,
  }) async {
    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      throw FileSystemException('Source image does not exist.', sourcePath);
    }

    final directory = await getScreenshotsDirectory();

    final extension = path.extension(sourcePath).isEmpty
        ? '.jpg'
        : path.extension(sourcePath);

    final fileName = '$imageHash$extension';

    final destinationPath = path.join(directory.path, fileName);

    final destinationFile = File(destinationPath);

    if (await destinationFile.exists()) {
      return destinationPath;
    }

    final copiedFile = await sourceFile.copy(destinationPath);

    return copiedFile.path;
  }

  /// Deletes a stored image.
  static Future<bool> deleteImage(String imagePath) async {
    final imageFile = File(imagePath);

    if (!await imageFile.exists()) {
      return false;
    }

    await imageFile.delete();

    return true;
  }

  /// Deletes all files stored in the app's screenshots directory.
  static Future<void> clearScreenshotsDirectory() async {
    final directory = await getScreenshotsDirectory();

    if (!await directory.exists()) return;

    await for (final entity in directory.list()) {
      await entity.delete(recursive: true);
    }
  }
}
