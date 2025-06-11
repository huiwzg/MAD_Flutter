import 'package:flutter/material.dart';
import 'package:mad_flutter/detailed_word_information.dart';

class FlashcardEditWidget extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;

  const FlashcardEditWidget({
    required this.controller1,
    required this.controller2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller1,
            decoration: InputDecoration(labelText: 'Term'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller2,
            decoration: InputDecoration(labelText: 'Definition'),
          ),
        ],
      ),
    );
  }
}

class FlashcardWidget extends StatelessWidget {
  final String backText;
  final String frontText;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onSelfEvalCorrect;
  final VoidCallback onSelfEvalIncorrect;

  const FlashcardWidget({
    required this.backText,
    required this.frontText,
    required this.isFlipped,
    required this.onFlip,
    required this.onSelfEvalCorrect,
    required this.onSelfEvalIncorrect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: onFlip,
          child: Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white, // fondo adaptable
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isFlipped ? backText : frontText,
                style: TextStyle(
                  fontSize: 24,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (isFlipped) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onSelfEvalCorrect,
                child: const Text('Correct'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: onSelfEvalIncorrect,
                child: const Text('Incorrect'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailedWordPage(word: frontText),
                ),
              );
            },
            child: Text('More info about "$frontText"'),
          ),
        ],
      ],
    );
  }
}