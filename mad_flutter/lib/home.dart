import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mad_flutter/database_helper.dart';
import 'package:mad_flutter/library.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mad_flutter/mapscreen.dart';
import 'package:mad_flutter/streakstorage.dart';
import 'package:mad_flutter/score_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> recents = [];
  List<Map<String, String>> leaderboard = [];

  int streak = 0;
  bool activeToday = false;

  @override
  void initState() {
    super.initState();

    loadRecents();
    loadLeaderboard();

    StreakStorage.update(false);
    loadStreak();
  }

  void loadStreak() async {
    final _streak = await StreakStorage.getStreak();
    final _activeToday = await StreakStorage.wasActiveToday();
    setState(() {
      streak = _streak;
      activeToday = _activeToday;
    });
  }

  void loadLeaderboard() async {
    final _leaderboard = await ScoreManager.downloadScores();
    setState(() {
      leaderboard = _leaderboard;
    });
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
                          loadLeaderboard();
                          loadStreak();
                        });
                      },
                    )
                  );
                },
              ),
            ),
            
            Text("You have a ${streak} day streak!"),
            if (!activeToday) ...[
              Text("Complete a study set today to keep your streak!"),
            ],
            SizedBox(height: 15),
            Text("Leaderboard", style: TextStyle(fontSize: 25)),
            Expanded(
              child: ListView.builder(
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(leaderboard[index]['name'] ?? "??"),
                      subtitle: Text("Streak: ${leaderboard[index]['score'] ?? "??"}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapScreen(entry: LocationEntry(
                              name: leaderboard[index]['name'] ?? "??",
                              latitude: double.tryParse(leaderboard[index]['latitude'] ?? "0") ?? 0,
                              longitude: double.tryParse(leaderboard[index]['longitude'] ?? "0") ?? 0,
                            )),
                          ),
                        );
                      },
                    )
                  );
                },
              ),
            ),
          ]
        ),
      )
    );
  }
}
