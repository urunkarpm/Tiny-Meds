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

class GeminiParsedMedicine {
  final String? name;
  final String? strength;
  final DateTime? expiryDate;

  GeminiParsedMedicine({this.name, this.strength, this.expiryDate});
}

class GeminiService {
  final Ref _ref;

  GeminiService(this._ref);

  Future<GeminiParsedMedicine?> parseMedicineBoxText(String rawText) async {
    try {
      final settingsAsync = _ref.read(settingsProvider);
      final apiKey = settingsAsync.valueOrNull?.geminiApiKey;

      if (apiKey == null || apiKey.isEmpty) {
        return null;
      }

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final prompt = '''
Analyze the following raw text extracted from a medicine box.
Extract the following information:
1. The exact name of the medicine.
2. The strength or dosage (e.g., 500mg, 10ml, etc.).
3. The expiry date, formatted as YYYY-MM-DD.

Raw Text:
"""
$rawText
"""

Return a JSON object with the following keys:
- "name": The medicine name, or null if not found.
- "strength": The strength/dosage, or null if not found.
- "expiryDate": The expiry date as a string (YYYY-MM-DD), or null if not found.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('Empty response from Gemini');
      }

      final Map<String, dynamic> jsonResponse =
          jsonDecode(response.text!.trim());

      DateTime? parsedExpiry;
      if (jsonResponse['expiryDate'] != null) {
        parsedExpiry = DateTime.tryParse(jsonResponse['expiryDate'] as String);
      }

      return GeminiParsedMedicine(
        name: jsonResponse['name'] as String?,
        strength: jsonResponse['strength'] as String?,
        expiryDate: parsedExpiry,
      );
    } catch (e, stack) {
      developer.log(
        'Failed to parse medicine box text using Gemini',
        name: 'myapp.gemini',
        level: 1000,
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

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
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final medicineName =
          brand != null && brand.isNotEmpty ? '$brand ($name)' : name;

      final prompt = '''
Provide a brief summary (2-3 sentences) and the primary chemical composition of the medicine named "$medicineName".
Return a JSON object with the following keys:
- "summary": The 2-3 sentence summary.
- "composition": The primary active ingredients or chemical composition.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('Empty response from Gemini');
      }

      final Map<String, dynamic> jsonResponse =
          jsonDecode(response.text!.trim());

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
