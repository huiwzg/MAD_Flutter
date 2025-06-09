import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class ScoreManager {

  static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("");

  static Future<Position?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return null;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return null;
    }

    // If permissions are granted, get the position
    return await Geolocator.getCurrentPosition(locationSettings: AndroidSettings(accuracy: LocationAccuracy.high));
  }

  static void uploadScore(int newScore) async {
    Position? loc = await getUserLocation();
    _dbRef.child("users/${FirebaseAuth.instance.currentUser?.uid}").set({
      "name": "${FirebaseAuth.instance.currentUser?.displayName}",
      "score": "${newScore}",
      "latitude": "${loc?.latitude ?? "???"}",
      "longitude": "${loc?.longitude ?? "???"}"
    }).then((_) {
      print("Data written successfully!");
    }).catchError((error) {
      print("Failed to write data: $error");
    });
  }

  static Future<List<Map<String, String>>> downloadScores() async {
    DatabaseEvent event = await _dbRef.child("users").once();
    final tmp = event.snapshot.value;
    print(tmp);

    final map = (tmp as Map<Object?, Object?>).cast<String, dynamic>();
    return map.entries.map((entry) {
      final value = (entry.value as Map<Object?, Object?>).cast<String, dynamic>();
      return {
        'id': entry.key,
        'name': value['name'].toString(),
        'score': value['score'].toString(),
        'latitude': value['latitude'].toString(),
        'longitude': value['longitude'].toString()
      };
    }).toList();
  }
}
  
