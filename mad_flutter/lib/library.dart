import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/study.dart';


class LibraryPage extends StatefulWidget {  
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {

  List<Map<String, String>> studySetTitles = [];

  @override
  void initState() {
    super.initState();
    getStudySetSummary();
  }

  Future<void> getStudySetSummary() async {
    DatabaseHelper().getSummary().then((value) {
      setState(() {
        studySetTitles = value.map((e) => {'id' : e['id'].toString(), 'name' : e['name'].toString()}).toList();
      });
    });
    
  }

  void launchStudySet(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyPage(
          id: id,
        ),
      ),
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load study set')),
      );
    }).then((_){
      getStudySetSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh',
            onPressed: getStudySetSummary,
          ),
        ]
      ),
      // body: const Center(child: Text('TODO: Library Page')),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: getStudySetTitles,
          //   child: const Text('Get Study Set Titles'),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: studySetTitles.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(studySetTitles[index]['name']!),
                    onTap: () {
                      launchStudySet(studySetTitles[index]['id']!);
                    },
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}