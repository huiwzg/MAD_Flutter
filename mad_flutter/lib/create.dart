import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/flashcard.dart';

class CreatePage extends StatefulWidget {
  final String? id;

  CreatePage({super.key, this.id});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titleController = TextEditingController();

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];

  List<Widget> flashcardWidgets = [];

  @override
  void initState() {
    // TODO: implement initState
    if (widget.id != null) {
      DatabaseHelper().getSet(widget.id!).then((value) {
        titleController.text = value['name'] as String;
        List<Map<String, String>> flashcardFields = (json.decode(value['data']!) as List<dynamic>)
          .map<Map<String, String>>((item) => Map<String, String>.from(item))
          .toList();
        for (var field in flashcardFields) {
          addFlashcard(question: field['question'], answer: field['answer']);
        }
      });
    }
    super.initState();
  }

  void _saveStudySet() async {
    List<Map<String, String>> flashcardFields = [];

    for (int i = 0; i < questionControllers.length; i++) {
      flashcardFields.add({
        'question': questionControllers[i].text,
        'answer': answerControllers[i].text,
      });
    }

    if (widget.id == null) {
      DatabaseHelper().saveSet(titleController.text, flashcardFields).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study set saved!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save study set')),
        );
      });
    } else {
      DatabaseHelper().updateSet(widget.id!, titleController.text, json.encode(flashcardFields)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study set updated!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update study set')),
        );
      });
    }

    Navigator.pop(context); // Close the Create page after saving
  }

  void addFlashcard({String? question = "", String? answer = ""}) {
    final questionController = TextEditingController(text: question ?? "");
    final answerController = TextEditingController(text: answer ?? "");

    questionControllers.add(questionController);
    answerControllers.add(answerController);

    setState(() {
      flashcardWidgets.add(
        FlashcardEditWidget(
          controller1: questionController,
          controller2: answerController,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a study set'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_sharp),
            tooltip: 'Save',
            onPressed: _saveStudySet,
          ),
        ]),
      // body: const Center(child: Text('TODO: Create Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Study set #3',
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Title', textAlign: TextAlign.left,),
              ),
            ),
            Column(
              children: [
                ...flashcardWidgets,
                Container(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: ElevatedButton(
                    onPressed: addFlashcard,
                    child: const Text('Add Flashcard'),
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
