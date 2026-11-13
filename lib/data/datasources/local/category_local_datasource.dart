import 'package:sqflite/sqflite.dart';

import '../../database/app_database.dart';
import '../../database/database_tables.dart';
import '../../models/category_model.dart';

class CategoryLocalDatasource {
  final AppDatabase _appDatabase;

  CategoryLocalDatasource({required this._appDatabase});

  Future<int> insertCategory(CategoryModel category) async {
    final db = await _appDatabase.database;

    final categoryMap = category.toMap()..remove(CategoryColumns.id);

    return db.insert(
      DatabaseTables.categories,
      categoryMap,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _appDatabase.database;

    final result = await db.query(
      DatabaseTables.categories,
      orderBy: '${CategoryColumns.id} ASC',
    );

    return result.map(CategoryModel.fromMap).toList();
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    final db = await _appDatabase.database;

    final result = await db.query(
      DatabaseTables.categories,
      where: '${CategoryColumns.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return CategoryModel.fromMap(result.first);
  }

  Future<CategoryModel?> getCategoryByName(String name) async {
    final db = await _appDatabase.database;

    final result = await db.query(
      DatabaseTables.categories,
      where: '${CategoryColumns.name} = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return CategoryModel.fromMap(result.first);
  }
}
