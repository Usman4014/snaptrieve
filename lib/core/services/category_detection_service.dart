import '../../core/constants/app_constants.dart';
import '../../data/repositories/category_repository.dart';

class CategoryDetectionService {
  final CategoryRepository _categoryRepository;

  Future<void>? _initialization;

  CategoryDetectionService({required this._categoryRepository});

  static final RegExp _emailPattern = RegExp(
    r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
    caseSensitive: false,
  );

  static final RegExp _urlPattern = RegExp(
    r'\b(?:https?:\/\/|www\.)[^\s<>()]+|\b[a-zA-Z0-9-]+\.(?:com|org|net|edu|gov|io|co|pk|app|dev)(?:\/[^\s<>()]*)?',
    caseSensitive: false,
  );

  static final RegExp _phonePattern = RegExp(
    r'(?<!\w)(?:\+?\d{1,3}[\s.-]?)?(?:\(?\d{2,4}\)?[\s.-]?)\d{3,4}[\s.-]?\d{3,4}(?!\w)',
  );

  static final RegExp _numericDatePattern = RegExp(
    r'\b(?:\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{4}[/-]\d{1,2}[/-]\d{1,2})\b',
  );

  static final RegExp _monthDatePattern = RegExp(
    r'\b(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)\s+\d{1,2}(?:,?\s+\d{4})?\b|\b\d{1,2}\s+(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)\s+\d{4}\b',
    caseSensitive: false,
  );

  static final RegExp _eventKeywordPattern = RegExp(
    r'\b(meeting|appointment|event|deadline|birthday|interview|reminder|schedule|conference|webinar)\b',
    caseSensitive: false,
  );

  Future<int?> detectCategoryId(String extractedText) async {
    _initialization ??= _categoryRepository.initializeDefaultCategories();

    await _initialization;

    final text = extractedText.trim();

    late final String categoryName;

    if (text.isEmpty) {
      categoryName = DefaultCategories.uncategorized;
    } else if (_emailPattern.hasMatch(text)) {
      categoryName = DefaultCategories.emails;
    } else if (_urlPattern.hasMatch(text)) {
      categoryName = DefaultCategories.links;
    } else if (_phonePattern.hasMatch(text)) {
      categoryName = DefaultCategories.contacts;
    } else if (_numericDatePattern.hasMatch(text) ||
        _monthDatePattern.hasMatch(text) ||
        _eventKeywordPattern.hasMatch(text)) {
      categoryName = DefaultCategories.datesAndEvents;
    } else {
      categoryName = DefaultCategories.generalText;
    }

    final category = await _categoryRepository.getCategoryByName(categoryName);

    return category?.id;
  }
}
