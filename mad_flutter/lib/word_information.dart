import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> wordInformation(String word) async {
  final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.first as Map<String, dynamic>;
  } else {
    return null;
  }
}