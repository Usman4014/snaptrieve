import 'database_tables.dart';

class DatabaseMigrations {
  DatabaseMigrations._();

  static const int databaseVersion = 1;

  static const String createCategoriesTable =
      '''
    CREATE TABLE ${DatabaseTables.categories} (
      ${CategoryColumns.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${CategoryColumns.name} TEXT NOT NULL UNIQUE,
      ${CategoryColumns.icon} TEXT NOT NULL,
      ${CategoryColumns.createdAt} TEXT NOT NULL
    )
  ''';

  static const String createScreenshotsTable =
      '''
    CREATE TABLE ${DatabaseTables.screenshots} (
      ${ScreenshotColumns.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ScreenshotColumns.imagePath} TEXT NOT NULL,
      ${ScreenshotColumns.imageHash} TEXT NOT NULL UNIQUE,
      ${ScreenshotColumns.extractedText} TEXT NOT NULL DEFAULT '',
      ${ScreenshotColumns.categoryId} INTEGER,
      ${ScreenshotColumns.createdAt} TEXT NOT NULL,
      ${ScreenshotColumns.updatedAt} TEXT NOT NULL,
      ${ScreenshotColumns.isProcessed} INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (${ScreenshotColumns.categoryId})
        REFERENCES ${DatabaseTables.categories} (${CategoryColumns.id})
        ON DELETE SET NULL
    )
  ''';

  static const String createScreenshotCategoryIndex =
      '''
    CREATE INDEX idx_screenshots_category
    ON ${DatabaseTables.screenshots} (${ScreenshotColumns.categoryId})
  ''';

  static const String createScreenshotDateIndex =
      '''
    CREATE INDEX idx_screenshots_created_at
    ON ${DatabaseTables.screenshots} (${ScreenshotColumns.createdAt})
  ''';

  static const String createScreenshotProcessedIndex =
      '''
    CREATE INDEX idx_screenshots_processed
    ON ${DatabaseTables.screenshots} (${ScreenshotColumns.isProcessed})
  ''';
}
