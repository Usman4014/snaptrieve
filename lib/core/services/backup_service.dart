import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:snaptrieve/core/utils/file_utils.dart';

import '../../data/database/app_database.dart';

class BackupService {
  BackupService._();

  static final BackupService instance = BackupService._();

  static const int _backupVersion = 1;
  static const String _metadataFileName = 'backup.json';
  static const String _imagesDirectory = 'images';

  Future<Uint8List> createBackup() async {
    final database = await AppDatabase.instance.database;

    final categories = await database.query('categories', orderBy: 'id ASC');

    final screenshots = await database.query('screenshots', orderBy: 'id ASC');

    final archive = Archive();
    final backupScreenshots = <Map<String, dynamic>>[];

    for (final screenshot in screenshots) {
      final imagePath = screenshot['image_path'] as String;
      final imageFile = File(imagePath);

      if (!await imageFile.exists()) {
        throw Exception('A screenshot image is missing.');
      }

      final imageBytes = await imageFile.readAsBytes();
      final imageFileName = path.basename(imagePath);

      archive.addFile(
        ArchiveFile(
          '$_imagesDirectory/$imageFileName',
          imageBytes.length,
          imageBytes,
        ),
      );

      final screenshotData = Map<String, dynamic>.from(screenshot);
      screenshotData.remove('image_path');
      screenshotData['image_file_name'] = imageFileName;

      backupScreenshots.add(screenshotData);
    }

    final metadata = {
      'backup_version': _backupVersion,
      'created_at': DateTime.now().toIso8601String(),
      'categories': categories,
      'screenshots': backupScreenshots,
    };

    final metadataBytes = utf8.encode(jsonEncode(metadata));

    archive.addFile(
      ArchiveFile(_metadataFileName, metadataBytes.length, metadataBytes),
    );

    final zipBytes = ZipEncoder().encode(archive);

    return Uint8List.fromList(zipBytes);
  }

  Future<void> restoreBackup(Uint8List backupBytes) async {
    final archive = ZipDecoder().decodeBytes(backupBytes);

    final metadataFile = archive.findFile(_metadataFileName);

    if (metadataFile == null) {
      throw Exception('Invalid backup file.');
    }

    final metadata = jsonDecode(utf8.decode(metadataFile.content as List<int>));

    if (metadata is! Map || metadata['backup_version'] != _backupVersion) {
      throw Exception('Unsupported or invalid backup version.');
    }

    final categories = metadata['categories'];
    final screenshots = metadata['screenshots'];

    if (categories is! List || screenshots is! List) {
      throw Exception('Backup data is incomplete.');
    }

    final categoryIds = <int>{};
    final categoryNames = <String>{};

    for (final category in categories) {
      if (category is! Map ||
          category['id'] is! int ||
          category['name'] is! String ||
          category['icon'] is! String ||
          category['created_at'] is! String) {
        throw Exception('Invalid category data in backup.');
      }

      final id = category['id'] as int;
      final name = (category['name'] as String).trim();

      if (id <= 0 ||
          name.isEmpty ||
          !categoryIds.add(id) ||
          !categoryNames.add(name)) {
        throw Exception('Duplicate or invalid category in backup.');
      }
    }

    final extractedImages = <String, List<int>>{};
    final screenshotIds = <int>{};
    final screenshotHashes = <String>{};

    for (final screenshot in screenshots) {
      if (screenshot is! Map ||
          screenshot['id'] is! int ||
          screenshot['image_hash'] is! String ||
          screenshot['extracted_text'] is! String ||
          screenshot['created_at'] is! String ||
          screenshot['updated_at'] is! String ||
          screenshot['is_processed'] is! int ||
          screenshot['image_file_name'] is! String) {
        throw Exception('Invalid screenshot data in backup.');
      }

      final screenshotId = screenshot['id'] as int;
      final imageHash = screenshot['image_hash'] as String;
      final imageFileName = screenshot['image_file_name'] as String;
      final categoryId = screenshot['category_id'];

      if (screenshotId <= 0 ||
          !screenshotIds.add(screenshotId) ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch(imageHash) ||
          !screenshotHashes.add(imageHash) ||
          imageFileName.isEmpty ||
          path.basename(imageFileName) != imageFileName ||
          (categoryId != null &&
              (categoryId is! int || !categoryIds.contains(categoryId)))) {
        throw Exception('Invalid screenshot references in backup.');
      }

      final imageArchiveFile = archive.findFile(
        '$_imagesDirectory/$imageFileName',
      );

      if (imageArchiveFile == null) {
        throw Exception('A backup image is missing.');
      }

      final imageBytes = List<int>.from(imageArchiveFile.content as List<int>);

      final actualHash = sha256.convert(imageBytes).toString();

      if (actualHash != imageHash) {
        throw Exception('Backup image verification failed.');
      }

      extractedImages[imageFileName] = imageBytes;
    }

    final database = await AppDatabase.instance.database;
    final screenshotDirectory = await FileUtils.getScreenshotsDirectory();

    final previousScreenshots = await database.query('screenshots');

    final previousImagePaths = previousScreenshots
        .map((item) => item['image_path'] as String)
        .toSet();

    final copiedImagePaths = <String>[];
    final restoredImagePaths = <String>{};

    try {
      for (final entry in extractedImages.entries) {
        final destinationPath = path.join(screenshotDirectory.path, entry.key);

        final destinationFile = File(destinationPath);

        if (await destinationFile.exists()) {
          final existingHash = sha256
              .convert(await destinationFile.readAsBytes())
              .toString();

          if (existingHash != sha256.convert(entry.value).toString()) {
            throw Exception('An existing image conflicts with the backup.');
          }
        } else {
          await destinationFile.writeAsBytes(entry.value);
          copiedImagePaths.add(destinationPath);
        }

        restoredImagePaths.add(destinationPath);
      }

      await database.transaction((transaction) async {
        await transaction.delete('screenshots');
        await transaction.delete('categories');

        for (final category in categories) {
          await transaction.insert(
            'categories',
            Map<String, dynamic>.from(category as Map),
          );
        }

        for (final screenshot in screenshots) {
          final screenshotData = Map<String, dynamic>.from(screenshot as Map);

          final imageFileName =
              screenshotData.remove('image_file_name') as String;

          screenshotData['image_path'] = path.join(
            screenshotDirectory.path,
            imageFileName,
          );

          await transaction.insert('screenshots', screenshotData);
        }
      });
    } catch (_) {
      for (final imagePath in copiedImagePaths) {
        final imageFile = File(imagePath);

        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }

      rethrow;
    }

    // Remove old images only after the database transaction succeeds.
    for (final oldPath in previousImagePaths) {
      if (restoredImagePaths.contains(oldPath)) continue;

      try {
        final oldFile = File(oldPath);

        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      } catch (_) {
        // A cleanup failure must not undo a successful restore.
      }
    }
  }
}
