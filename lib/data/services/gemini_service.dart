import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../presentation/providers/settings_provider.dart';

class GeminiSummaryResult {
  final String summary;
  final String chemicalComposition;

  GeminiSummaryResult(
      {required this.summary, required this.chemicalComposition});
}

class GeminiService {
  final Ref _ref;

  GeminiService(this._ref);

  Future<GeminiSummaryResult?> generateMedicineSummary(
      String name, String? brand) async {
    try {
      final settingsAsync = _ref.read(settingsProvider);
      final apiKey = settingsAsync.valueOrNull?.geminiApiKey;

      if (apiKey == null || apiKey.isEmpty) {
        return null; // No API key configured
      }

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final medicineName = brand != null && brand.isNotEmpty
          ? '$brand ($name)'
          : name;

      final prompt = '''
Provide a brief summary (2-3 sentences) and the primary chemical composition of the medicine named "$medicineName".
Return the result strictly as a valid JSON object with the following keys:
- "summary": The 2-3 sentence summary.
- "composition": The primary active ingredients or chemical composition.
Do not include any markdown formatting (like ```json). Just return the raw JSON object.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('Empty response from Gemini');
      }

      var text = response.text!.trim();
      // Clean up markdown if the model still returns it
      if (text.startsWith('```json')) {
        text = text.substring(7);
      }
      if (text.startsWith('```')) {
        text = text.substring(3);
      }
      if (text.endsWith('```')) {
        text = text.substring(0, text.length - 3);
      }
      
      final Map<String, dynamic> jsonResponse = jsonDecode(text.trim());

      return GeminiSummaryResult(
        summary: jsonResponse['summary'] ?? 'Summary not available.',
        chemicalComposition:
            jsonResponse['composition'] ?? 'Composition not available.',
      );
    } catch (e, stack) {
      developer.log(
        'Failed to generate Gemini summary',
        name: 'myapp.gemini',
        level: 1000,
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }
}

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(ref);
});
