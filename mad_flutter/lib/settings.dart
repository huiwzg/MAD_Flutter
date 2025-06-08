import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsMenu {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Settings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      },
    );
  }
}