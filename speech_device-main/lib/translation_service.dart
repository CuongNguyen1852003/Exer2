import 'package:google_cloud_translation/google_cloud_translation.dart';

class TranslationService {
  final Translation _translation = Translation(
    apiKey: 'YOUR_API_KEY', // Replace with your actual API key
  );

  final Map<String, String> _supportedLanguages = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Russian': 'ru',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Chinese (Simplified)': 'zh',
  };

  Map<String, String> get supportedLanguages => _supportedLanguages;

  Future<String> translateText({
    required String text,
    required String targetLanguage,
  }) async {
    try {
      if (text.isEmpty) return '';
      
      final response = await _translation.translate(
        text: text,
        to: targetLanguage,
      );

      return response.translatedText;
    } catch (e) {
      print('Translation error: $e');
      return 'Translation error occurred';
    }
  }
} 