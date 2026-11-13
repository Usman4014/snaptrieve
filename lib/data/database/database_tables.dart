class DatabaseTables {
  DatabaseTables._();

  static const String screenshots = 'screenshots';
  static const String categories = 'categories';
}

class ScreenshotColumns {
  ScreenshotColumns._();

  static const String id = 'id';
  static const String imagePath = 'image_path';
  static const String imageHash = 'image_hash';
  static const String extractedText = 'extracted_text';
  static const String categoryId = 'category_id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String isProcessed = 'is_processed';
}

class CategoryColumns {
  CategoryColumns._();

  static const String id = 'id';
  static const String name = 'name';
  static const String icon = 'icon';
  static const String createdAt = 'created_at';
}
