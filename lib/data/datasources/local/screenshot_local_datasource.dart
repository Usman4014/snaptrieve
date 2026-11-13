import 'package:sqflite/sqflite.dart';

import '../../database/app_database.dart';
import '../../database/database_tables.dart';
import '../../models/screenshot_model.dart';

class ScreenshotLocalDatasource {
  final AppDatabase _appDatabase;

  ScreenshotLocalDatasource({required this._appDatabase});

  Future<Database> get _database async {
    return _appDatabase.database;
  }

  /// Deletes all screenshot records while preserving categories.
  Future<int> deleteAllScreenshots() async {
    final db = await _database;

    return db.delete(DatabaseTables.screenshots);
  }

  /// Inserts a screenshot into the database.
  Future<int> insertScreenshot(ScreenshotModel screenshot) async {
    final db = await _database;

    return db.insert(
      DatabaseTables.screenshots,
      screenshot.toMap()..remove(ScreenshotColumns.id),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> getCountByCategory(int categoryId) async {
    final db = await _appDatabase.database;

    final result = await db.rawQuery(
      '''
    SELECT COUNT(*)
    FROM ${DatabaseTables.screenshots}
    WHERE ${ScreenshotColumns.categoryId} = ?
    ''',
      [categoryId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Fetches all screenshots.
  Future<List<ScreenshotModel>> getAllScreenshots() async {
    final db = await _database;

    final result = await db.query(
      DatabaseTables.screenshots,
      orderBy: '${ScreenshotColumns.createdAt} DESC',
    );

    return result.map(ScreenshotModel.fromMap).toList();
  }

  /// Fetches a screenshot by its database ID.
  Future<ScreenshotModel?> getScreenshotById(int id) async {
    final db = await _database;

    final result = await db.query(
      DatabaseTables.screenshots,
      where: '${ScreenshotColumns.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return ScreenshotModel.fromMap(result.first);
  }

  /// Checks whether an image already exists using its hash.
  Future<bool> isDuplicate(String imageHash) async {
    final db = await _database;

    final result = await db.query(
      DatabaseTables.screenshots,
      columns: [ScreenshotColumns.id],
      where: '${ScreenshotColumns.imageHash} = ?',
      whereArgs: [imageHash],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  /// Updates an existing screenshot.
  Future<int> updateScreenshot(ScreenshotModel screenshot) async {
    if (screenshot.id == null) {
      throw ArgumentError('Screenshot ID is required for update.');
    }

    final db = await _database;

    return db.update(
      DatabaseTables.screenshots,
      screenshot.toMap()..remove(ScreenshotColumns.id),
      where: '${ScreenshotColumns.id} = ?',
      whereArgs: [screenshot.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Deletes a screenshot by its database ID.
  Future<int> deleteScreenshot(int id) async {
    final db = await _database;

    return db.delete(
      DatabaseTables.screenshots,
      where: '${ScreenshotColumns.id} = ?',
      whereArgs: [id],
    );
  }

  /// Deletes multiple screenshots.
  Future<int> deleteScreenshots(List<int> ids) async {
    if (ids.isEmpty) return 0;

    final db = await _database;

    final placeholders = List.filled(ids.length, '?').join(', ');

    return db.delete(
      DatabaseTables.screenshots,
      where: '${ScreenshotColumns.id} IN ($placeholders)',
      whereArgs: ids,
    );
  }

  /// Returns total number of stored screenshots.
  Future<int> getTotalCount() async {
    final db = await _database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM ${DatabaseTables.screenshots}',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Returns total number of processed screenshots.
  Future<int> getProcessedCount() async {
    final db = await _database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) AS total
      FROM ${DatabaseTables.screenshots}
      WHERE ${ScreenshotColumns.isProcessed} = 1
      ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
