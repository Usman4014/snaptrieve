class DetectedInformationModel {
  final String type;
  final String value;

  const DetectedInformationModel({required this.type, required this.value});

  static const String link = 'Link';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String date = 'Date';

  static final RegExp _emailPattern = RegExp(
    r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
    caseSensitive: false,
  );

  static final RegExp _urlPattern = RegExp(
    r'\b(?:https?://|www\.)[^\s<>()]+|\b[a-zA-Z0-9-]+\.(?:com|org|net|edu|gov|io|co|pk|app|dev)(?:/[^\s<>()]*)?',
    caseSensitive: false,
  );

  static final RegExp _phonePattern = RegExp(
    r'(?<!\w)(?:\+?\d{1,3}[\s.-]?)?(?:\(?\d{2,4}\)?[\s.-]?)\d{3,4}[\s.-]?\d{3,4}(?!\w)',
  );

  static final RegExp _datePattern = RegExp(
    r'\b(?:\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{4}[/-]\d{1,2}[/-]\d{1,2})\b|\b(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)\s+\d{1,2}(?:,?\s+\d{4})?\b',
    caseSensitive: false,
  );

  static List<DetectedInformationModel> detect(String text) {
    final results = <DetectedInformationModel>[];

    void addMatches(RegExp pattern, String type) {
      for (final match in pattern.allMatches(text)) {
        final value = match.group(0)?.trim();

        if (value == null || value.isEmpty) continue;

        final normalizedValue = value.replaceAll(RegExp(r'[,.;:]+$'), '');

        if (normalizedValue.isEmpty) continue;

        if (!results.any(
          (item) =>
              item.type == type &&
              item.value.toLowerCase() == normalizedValue.toLowerCase(),
        )) {
          results.add(
            DetectedInformationModel(type: type, value: normalizedValue),
          );
        }
      }
    }

    addMatches(_urlPattern, link);
    addMatches(_emailPattern, email);
    addMatches(_phonePattern, phone);
    addMatches(_datePattern, date);

    return results;
  }
}
