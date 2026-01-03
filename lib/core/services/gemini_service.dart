import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // 🔑 PUT YOUR REAL API KEY HERE
  static const String _apiKey ='';

  // ✅ CORRECT, STABLE ENDPOINT (v1, NOT v1beta)
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Gemini error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
