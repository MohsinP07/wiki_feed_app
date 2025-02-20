import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wikifeed_app/utils/secrets.dart';

class TopicServices {
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

  Future<List<String>> getGeminiTopics(String category) async {
    final response = await http.post(
      Uri.parse('$apiUrl?key=$GEMINI_API'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Give me a list of 10 popular topics related to $category that exist on Wikipedia.'
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String textResponse =
          data['candidates'][0]['content']['parts'][0]['text'];

      List<String> topics = textResponse
          .split('\n')
          .map(
              (e) => e.replaceAll(RegExp(r'^\d+\.\s*'), '')) 
          .where((e) => e.isNotEmpty)
          .toList();

      return topics.take(10).toList(); 
    } else {
      print('Error fetching topics: ${response.body}');
      return [];
    }
  }
}
