import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> recents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child:  Column(
          children: [
            Text("Recent sets", style: TextStyle(fontSize: 25)),
            Row(children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text("Set title"),
                  onTap: () {
                    // launchStudySet(studySetTitles[index]['id']!);
                  },
                )
              )
            ]),
          ],
        ),
      )
    );
  }
}
