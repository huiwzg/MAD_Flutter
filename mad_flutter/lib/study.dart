import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/flashcard.dart';

class StudyPage extends StatefulWidget {
  final String id;

  const StudyPage({super.key, required this.id});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int currentIndex = 0;
  bool isFlipped = false;

  late final String? title;
  late final List<Map<String, String>>? flashcardFields;

  bool isLoading = true;

  @override
  void initState() {
    DatabaseHelper().getSet(widget.id).then((value) {
      setState(() {
        title = value['name'] as String;
        flashcardFields = (json.decode(value['data']!) as List<dynamic>)
          .map<Map<String, String>>((item) => Map<String, String>.from(item))
          .toList();
        isLoading = false;
        print("raw json: ${value['data']}");
        print("fcF.l: ${flashcardFields!.length}");
      });
    });
    super.initState();
  }

  void flipCard() {
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  void nextCard() { // Prevent interaction while loading

    setState(() {
      print("Current index: ${currentIndex.toString()}. Next: ${(currentIndex + 1) % flashcardFields!.length}. fcF.l: ${flashcardFields!.length}");
      currentIndex = (currentIndex + 1) % flashcardFields!.length; // Loop back to the first card
      isFlipped = false; // Reset the flip state when moving to the next card
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (flashcardFields == null || flashcardFields!.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Study Set'),
          ),
          body: const Center(
            child: Text('No flashcards available.'),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(title: Text(title!)),
        body: Center(
          child: FlashcardWidget(
            controller1: TextEditingController(text: flashcardFields![currentIndex]['question']),
            controller2: TextEditingController(text: flashcardFields![currentIndex]['answer']),
            isFlipped: isFlipped,
            onFlip: flipCard,
            onNext: nextCard,
          ),
        ),
      );
    }
  }
}