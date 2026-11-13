import '../database/database_tables.dart';

class CategoryModel {
  final int? id;
  final String name;
  final String icon;
  final DateTime createdAt;

  const CategoryModel({
    this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map[CategoryColumns.id] as int?,
      name: map[CategoryColumns.name] as String,
      icon: map[CategoryColumns.icon] as String,
      createdAt: DateTime.parse(map[CategoryColumns.createdAt] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) CategoryColumns.id: id,
      CategoryColumns.name: name,
      CategoryColumns.icon: icon,
      CategoryColumns.createdAt: createdAt.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? icon,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
