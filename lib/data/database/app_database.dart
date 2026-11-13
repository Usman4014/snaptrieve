import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'database_migrations.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String _databaseName = 'snaptrieve.db';

  Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final databaseDirectory = await getDatabasesPath();
    final databasePath = path.join(databaseDirectory, _databaseName);

    return openDatabase(
      databasePath,
      version: DatabaseMigrations.databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseMigrations.createCategoriesTable);

    await db.execute(DatabaseMigrations.createScreenshotsTable);

    await db.execute(DatabaseMigrations.createScreenshotCategoryIndex);

    await db.execute(DatabaseMigrations.createScreenshotDateIndex);

    await db.execute(DatabaseMigrations.createScreenshotProcessedIndex);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future database migrations will be handled here.
  }

  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
