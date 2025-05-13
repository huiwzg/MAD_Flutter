import 'package:flutter/material.dart';
import 'package:mad_flutter/auth_gate.dart';
import 'package:mad_flutter/create.dart';
import 'package:mad_flutter/library.dart';
import 'package:mad_flutter/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: AuthGate(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final GlobalKey<LibraryPageState> childKey = GlobalKey();

  List<Widget> _pages = [];

  @override
  void initState() {
    _pages = [
      HomePage(),
      CreatePage(id: null),
      LibraryPage(key: childKey),
    ];

    super.initState();
  }

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
          print("Tapped index: $index");
          if (index == 1) {
            // Open the Create page in a new screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePage(id: null)),
            ).then((_) {
              // Refresh the Library page after returning from Create page
              if (childKey.currentState != null) {
                setState(() {
                  childKey.currentState!.getStudySetSummary();
                });
              }
            });
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

