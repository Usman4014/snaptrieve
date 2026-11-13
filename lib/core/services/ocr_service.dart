import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  bool _isClosed = false;

  /// Extracts text from an image using on-device ML Kit OCR.
  Future<String> extractText(String imagePath) async {
    if (_isClosed) {
      throw StateError('OCR service has already been closed.');
    }

    final inputImage = InputImage.fromFilePath(imagePath);

    final recognizedText = await _textRecognizer.processImage(inputImage);

    return recognizedText.text.trim();
  }

  /// Releases the text recognizer resources.
  Future<void> dispose() async {
    if (_isClosed) return;

    _isClosed = true;
    await _textRecognizer.close();
  }
}
