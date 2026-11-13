import '../../core/constants/app_constants.dart';
import '../datasources/local/category_local_datasource.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryLocalDatasource _localDatasource;

  CategoryRepository({required this._localDatasource});

  Future<void> initializeDefaultCategories() async {
    final now = DateTime.now();

    final defaultCategories = [
      CategoryModel(
        name: DefaultCategories.links,
        icon: DefaultCategories.linksIcon,
        createdAt: now,
      ),
      CategoryModel(
        name: DefaultCategories.emails,
        icon: DefaultCategories.emailsIcon,
        createdAt: now,
      ),
      CategoryModel(
        name: DefaultCategories.contacts,
        icon: DefaultCategories.contactsIcon,
        createdAt: now,
      ),
      CategoryModel(
        name: DefaultCategories.datesAndEvents,
        icon: DefaultCategories.datesAndEventsIcon,
        createdAt: now,
      ),
      CategoryModel(
        name: DefaultCategories.generalText,
        icon: DefaultCategories.generalTextIcon,
        createdAt: now,
      ),
      CategoryModel(
        name: DefaultCategories.uncategorized,
        icon: DefaultCategories.uncategorizedIcon,
        createdAt: now,
      ),
    ];

    for (final category in defaultCategories) {
      await _localDatasource.insertCategory(category);
    }
  }

  Future<List<CategoryModel>> getAllCategories() {
    return _localDatasource.getAllCategories();
  }

  Future<CategoryModel?> getCategoryById(int id) {
    return _localDatasource.getCategoryById(id);
  }

  Future<CategoryModel?> getCategoryByName(String name) {
    return _localDatasource.getCategoryByName(name);
  }
}
