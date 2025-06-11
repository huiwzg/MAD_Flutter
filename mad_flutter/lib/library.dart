import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/study.dart';
import 'package:mad_flutter/settings.dart';
import 'package:mad_flutter/theme/custom_themes/AppColors.dart';


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

  void getStudySetSummary() async {
    final _tmp_studySetTitles = await DatabaseHelper().getSummary();
    setState(() {
      studySetTitles = _tmp_studySetTitles;
    });
  }

  static Future<void> launchStudySet(context, String id) {
    return Navigator.push(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => SettingsMenu.show(context),
          ),
        ]
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: studySetTitles.length,
              itemBuilder: (context, index) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final textColor = isDark ? Colors.white : Colors.black;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.black : AppColors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      studySetTitles[index]['name']!,
                      style: TextStyle(color: textColor),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      launchStudySet(context, studySetTitles[index]['id']!);
                    },
                  ),
                );
              }
              ,
            ),
          ),
        ],
      ),
    );
  }
}