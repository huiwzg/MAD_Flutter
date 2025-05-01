import 'package:flutter/material.dart';
import 'package:mad_flutter/create.dart';
import 'package:mad_flutter/library.dart';
import 'package:mad_flutter/home.dart';

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
      home: MainScreen(),
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

