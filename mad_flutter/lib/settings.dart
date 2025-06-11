import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMenu {
  static void updatePref(String field, bool value) async {
    SharedPreferences prefsInst = await SharedPreferences.getInstance();
    prefsInst.setBool(field, value);
  }

  static void show(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        bool showTermOnFront = true;

        return StatefulBuilder(
          builder: (BuildContext context, setState) {

            SharedPreferences.getInstance().then((SharedPreferences prefs) {
              bool prefValue = prefs.getBool('show-term-on-front') ?? true;
              if (prefValue != showTermOnFront) {
                setState(() {
                  showTermOnFront = prefValue;
                });
              }
            });

            return Container(
              padding: EdgeInsets.all(16.0),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Settings",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  
                  Text("Show term on front of flashcard?"),
                  Switch(value: showTermOnFront, onChanged: (bool value) {
                    setState(() {
                      showTermOnFront = value;
                      updatePref('show-term-on-front', value);
                      print("switched to $value");
                    });
                  }),

                  SizedBox(height: 10),
                  Text("Signed in as ${FirebaseAuth.instance.currentUser?.email}"),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: Text("Sign out"),
                  ),

                  // Add settings here
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      child: Text("Close"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }
}