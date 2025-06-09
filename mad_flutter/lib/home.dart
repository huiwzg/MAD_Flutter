import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/library.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> recents = [];

  @override
  void initState() {
    super.initState();
    loadRecents();
  }

  void loadRecents() async {
    final _tmp_recents = await DatabaseHelper().getRecents(3);
    setState(() {
      recents = _tmp_recents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child:  Column(
          children: [
            Text("Recent sets", style: TextStyle(fontSize: 25)),
            Expanded(
              child: ListView.builder(
                itemCount: recents.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(recents[index]['name']!),
                      onTap: () {
                        LibraryPageState.launchStudySet(context, recents[index]['id']!).then((_) {
                          loadRecents();
                        });
                      },
                    )
                  );
                },
              ),
            )
          ]
        ),
      )
    );
  }
}
