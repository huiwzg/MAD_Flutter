import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mad_flutter/create.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/flashcard.dart';

import 'package:logger/logger.dart';

class StudyPage extends StatefulWidget {
  final String id;

  const StudyPage({super.key, required this.id});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int currentIndex = 0;
  bool isFlipped = false;

  late String? title;
  late List<Map<String, String>>? flashcardFields;

  bool isLoading = true;

  @override
  void initState() {
    loadSet();
    super.initState();
  }

  void loadSet() {
    Logger().d('Loading study set with ID: ${widget.id}');
    isLoading = true;
    DatabaseHelper().getSet(widget.id).then((value) {
      setState(() {
        title = value['name'] as String;
        flashcardFields = (json.decode(value['data']!) as List<dynamic>)
          .map<Map<String, String>>((item) => Map<String, String>.from(item))
          .toList();
        isLoading = false;
      });
    });
  }

  void flipCard() {
    setState(() {
      isFlipped = !isFlipped;
    });
    Logger().d('Flipped card to ${isFlipped ? 'answer' : 'question'}');
  }

  void nextCard() { // Prevent interaction while loading
    setState(() {
      currentIndex = (currentIndex + 1) % flashcardFields!.length; // Loop back to the first card
      isFlipped = false; // Reset the flip state when moving to the next card
    });
    Logger().d('Moved to next card: $currentIndex');
  }

  void prevCard() { // Prevent interaction while loading
    setState(() {
      currentIndex = (currentIndex - 1) % flashcardFields!.length; // Loop back to the first card
      isFlipped = false; // Reset the flip state when moving to the next card
    });
    Logger().d('Moved to previous card: $currentIndex');
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
        appBar: AppBar(
          title: Text(title!),
          actions: [
            PopupMenuButton(itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
            ], onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePage(id: widget.id))).then((_) {
                  // Reload the study set after editing
                  loadSet();
                  print("Reloaded study set after editing.");
                });

              } else if (value == 'delete') {
                // Handle delete action
                DatabaseHelper().deleteSet(widget.id).then((_) {
                  Navigator.pop(context); // Close the Study page after deletion
                });
              } else if (value == 'settings') {
                // Handle settings action
                
              }
            })
          ],
        ),
        body: Center(
          child: FlashcardWidget(
            termText: flashcardFields![currentIndex]['question']!,
            defText: flashcardFields![currentIndex]['answer']!,
            isFlipped: isFlipped,
            onFlip: flipCard,
            onPrev: prevCard,
            onNext: nextCard,
          ),
        ),
      );
    }
  }
}