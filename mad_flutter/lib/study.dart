import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mad_flutter/create.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/flashcard.dart';

import 'package:logger/logger.dart';
import 'package:mad_flutter/streakstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool showTermOnFront = true;

  @override
  void initState() {
    loadSet();
    super.initState();
  }

  void loadSet() async {
    Logger().d('Loading study set with ID: ${widget.id}');
    isLoading = true;

    SharedPreferences prefsInst = await SharedPreferences.getInstance();
    showTermOnFront = prefsInst.getBool('show-term-on-front') ?? true;
    
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

  void selfEvalCorrect() {
    setState(() {
      flashcardFields!.removeRange(currentIndex, currentIndex+1);
      if (flashcardFields!.isEmpty) {
        currentIndex = 0;
      } else {
        currentIndex = currentIndex % flashcardFields!.length;
      }
      isFlipped = false;
    });
  }

  void selfEvalIncorrect() {
    setState(() {
      // flashcardFields!.removeRange(currentIndex, currentIndex+1);
      nextCard();
    });
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
        StreakStorage.update(true);
        return Scaffold(
          appBar: AppBar(
            title: Text((title == null) ? "Study set" : title!),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                const Text('You completed this set!'),
                SizedBox(height: 10),
                ElevatedButton(onPressed: loadSet, child: const Text("Reset")),
              ]
            ),
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
            frontText: flashcardFields![currentIndex][showTermOnFront ? 'question' : 'answer']!,
            backText: flashcardFields![currentIndex][showTermOnFront ? 'answer' : 'question']!,
            isFlipped: isFlipped,
            onFlip: flipCard,
            onSelfEvalCorrect: selfEvalCorrect,
            onSelfEvalIncorrect: selfEvalIncorrect,
          ),
        ),
      );
    }
  }
}