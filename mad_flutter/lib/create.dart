import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/flashcard.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titleController = TextEditingController();

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];

  List<Widget> flashcardWidgets = [];

  void _saveStudySet() async {
    List<Map<String, String>> flashcardFields = [];

    for (int i = 0; i < questionControllers.length; i++) {
      flashcardFields.add({
        'question': questionControllers[i].text,
        'answer': answerControllers[i].text,
      });
    }

    DatabaseHelper().saveSet(titleController.text, flashcardFields).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Study set saved!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save study set')),
      );
    });

    Navigator.pop(context); // Close the Create page after saving
  }

  void addFlashcard() {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

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
