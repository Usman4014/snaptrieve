import '../database/database_tables.dart';

class ScreenshotModel {
  final int? id;
  final String imagePath;
  final String imageHash;
  final String extractedText;
  final int? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isProcessed;

  const ScreenshotModel({
    this.id,
    required this.imagePath,
    required this.imageHash,
    this.extractedText = '',
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.isProcessed = false,
  });

  /// Converts SQLite map into ScreenshotModel.
  factory ScreenshotModel.fromMap(Map<String, dynamic> map) {
    return ScreenshotModel(
      id: map[ScreenshotColumns.id] as int?,
      imagePath: map[ScreenshotColumns.imagePath] as String,
      imageHash: map[ScreenshotColumns.imageHash] as String,
      extractedText: map[ScreenshotColumns.extractedText] as String? ?? '',
      categoryId: map[ScreenshotColumns.categoryId] as int?,
      createdAt: DateTime.parse(map[ScreenshotColumns.createdAt] as String),
      updatedAt: DateTime.parse(map[ScreenshotColumns.updatedAt] as String),
      isProcessed: (map[ScreenshotColumns.isProcessed] as int) == 1,
    );
  }

  /// Converts ScreenshotModel into SQLite map.
  Map<String, dynamic> toMap() {
    return {
      ScreenshotColumns.id: id,
      ScreenshotColumns.imagePath: imagePath,
      ScreenshotColumns.imageHash: imageHash,
      ScreenshotColumns.extractedText: extractedText,
      ScreenshotColumns.categoryId: categoryId,
      ScreenshotColumns.createdAt: createdAt.toIso8601String(),
      ScreenshotColumns.updatedAt: updatedAt.toIso8601String(),
      ScreenshotColumns.isProcessed: isProcessed ? 1 : 0,
    };
  }

  /// Creates a copy with updated values.
  ScreenshotModel copyWith({
    int? id,
    String? imagePath,
    String? imageHash,
    String? extractedText,
    int? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isProcessed,
    bool clearCategoryId = false,
  }) {
    return ScreenshotModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      imageHash: imageHash ?? this.imageHash,
      extractedText: extractedText ?? this.extractedText,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isProcessed: isProcessed ?? this.isProcessed,
    );
  }
}
