import '../datasources/local/screenshot_local_datasource.dart';
import '../models/screenshot_model.dart';

class ScreenshotRepository {
  final ScreenshotLocalDatasource _localDatasource;

  ScreenshotRepository({required this._localDatasource});

  /// Saves a screenshot if it does not already exist.
  /// Returns the inserted database ID, or null if duplicate.
  Future<int?> addScreenshot(ScreenshotModel screenshot) async {
    final isDuplicate = await _localDatasource.isDuplicate(
      screenshot.imageHash,
    );

    if (isDuplicate) return null;

    final id = await _localDatasource.insertScreenshot(screenshot);

    return id == 0 ? null : id;
  }

  /// Deletes all screenshot records from the database.
  Future<int> deleteAllScreenshots() {
    return _localDatasource.deleteAllScreenshots();
  }

  /// Fetches all saved screenshots.
  Future<List<ScreenshotModel>> getAllScreenshots() {
    return _localDatasource.getAllScreenshots();
  }

  /// Fetches a screenshot by ID.
  Future<ScreenshotModel?> getScreenshotById(int id) {
    return _localDatasource.getScreenshotById(id);
  }

  /// Checks whether a screenshot already exists.
  Future<bool> isDuplicate(String imageHash) {
    return _localDatasource.isDuplicate(imageHash);
  }

  /// Updates screenshot information.
  Future<bool> updateScreenshot(ScreenshotModel screenshot) async {
    final updatedRows = await _localDatasource.updateScreenshot(screenshot);

    return updatedRows > 0;
  }

  /// Deletes a screenshot by ID.
  Future<bool> deleteScreenshot(int id) async {
    final deletedRows = await _localDatasource.deleteScreenshot(id);

    return deletedRows > 0;
  }

  /// Deletes multiple screenshots.
  Future<int> deleteScreenshots(List<int> ids) {
    return _localDatasource.deleteScreenshots(ids);
  }

  /// Gets total screenshot count.
  Future<int> getTotalCount() {
    return _localDatasource.getTotalCount();
  }

  /// Gets processed screenshot count.
  Future<int> getProcessedCount() {
    return _localDatasource.getProcessedCount();
  }

  Future<int> getCountByCategory(int categoryId) {
    return _localDatasource.getCountByCategory(categoryId);
  }
}
