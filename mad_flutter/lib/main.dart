import 'package:flutter/material.dart';
import 'package:mad_flutter/flashcard.dart';
import 'package:mad_flutter/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const CreatePage(),
    const LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.library_add_outlined), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmarks_outlined), label: 'Library'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Open the Create page in a new screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePage()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('TODO: Home Page')),
    );
  }
}

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
  }

  void addFlashcard() {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    questionControllers.add(questionController);
    answerControllers.add(answerController);

    setState(() {
      flashcardWidgets.add(
        FlashcardWidget(
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

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: const Center(child: Text('TODO: Library Page')),
    );
  }
}