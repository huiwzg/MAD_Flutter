import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/flashcard.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  bool _validateTitle = false;

  @override
  void initState() {
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

  Future<void> _showBlankWarning() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your set has one or more blank fields!'),
          content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
            Text('Would you like to go back, or save the set with blanks?'),
            ],
          ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveStudySet();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkForBlanks() async {
    bool hasBlanks = false;
    
    if (titleController.text.isEmpty) {
      setState(() {
        _validateTitle = true;
      });

      Fluttertoast.showToast(
        msg: "Title cannot be empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      _validateTitle = false;
    });

    if (questionControllers.isEmpty) {
      Fluttertoast.showToast(
        msg: "Set must contain at least one flashcard!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }

    for (int i = 0; i < questionControllers.length; i++) {
      if (questionControllers[i].text.isEmpty || answerControllers[i].text.isEmpty) {
        hasBlanks = true;
      }
    }

    if (hasBlanks) {
      // Show a dialog if there are blanks
      await _showBlankWarning();
      return;
    } else {
      // If no blanks, proceed to save the study set
      _saveStudySet();
    }
  } 

  void _saveStudySet() async {
    List<Map<String, String>> flashcardFields = [];

    for (int i = 0; i < questionControllers.length; i++) {
      flashcardFields.add({
        'question': questionControllers[i].text,
        'answer': answerControllers[i].text,
      });
    }

    if (widget.id == null) { // null widget id implies new study set
      DatabaseHelper().saveSet(titleController.text, flashcardFields).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study set saved!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save study set')),
        );
      });
    } else { // if a widget id was provided, update the existing study set
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
            onPressed: _checkForBlanks,
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
                errorText: _validateTitle ? "Please enter a title" : null,
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
