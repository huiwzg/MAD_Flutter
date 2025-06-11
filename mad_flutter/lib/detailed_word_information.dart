import 'package:flutter/material.dart';
import 'package:mad_flutter/detailed_word_information.dart';
import 'package:mad_flutter/word_information.dart';

class DetailedWordPage extends StatefulWidget {
  final String word;

  const DetailedWordPage({super.key, required this.word});

  State<DetailedWordPage> createState() => _DetailedWordPageState();
}

class _DetailedWordPageState extends State<DetailedWordPage> {
  Map<String, dynamic>? _definition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    wordInformation(widget.word).then((data) {
      setState(() {
        _definition = data;
        _isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.word)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _definition == null
          ? const Center(child: Text('Word not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              widget.word,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._definition!['meanings'].map<Widget>((meaning) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meaning['partOfSpeech'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...meaning['definitions'].map<Widget>((def) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('- ${def['definition']}'),
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}