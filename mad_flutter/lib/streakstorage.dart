import 'package:mad_flutter/score_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakStorage {
  static const String _streakKey = 'streak';
  static const String _lastActivityKey = 'last_activity_day';

  static bool sameDay(DateTime a, DateTime b) {
    if (a.day == b.day && a.month == b.month && a.year == b.year) {
      return true;
    }
    return false;
  }

  // calling update(false) will check if the streak is stale (user was not 
  //  active yesterday) and reset it if necessary, but will not increment the 
  //  streak for today.
  // calling update(true) does the same except will increment the streak for
  //  today (if the streak is not stale)
  static Future<void> update(bool activeToday) async {
    final lastActivity = await getLastDate();
    final currentStreak = await getStreak();
    final now = DateTime.now();

    // if lastActivity is the same day as now, do nothing
    if (sameDay(lastActivity, now)) {
      return;
    }

    // if lastActivity is today - 1, increment streak and update lastDate
    if (sameDay(lastActivity, now.subtract(Duration(days: 1)))) {
      if (activeToday) {
        setStreak(currentStreak + 1);
        setLastDate(now);
      }
      return;
    }

    // (else) lastActivity is today - 2 or earlier, set streak to 1 and update lastDate
    setStreak(activeToday ? 1 : 0);
    if (activeToday) {
      setLastDate(now);
    }
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> setStreak(int value) async {
    ScoreManager.uploadScore(value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, value);
  }

  static Future<DateTime> getLastDate() async {
    final prefs = await SharedPreferences.getInstance();
    return DateTime.fromMillisecondsSinceEpoch(prefs.getInt(_lastActivityKey) ?? 0);
  }

  static Future<void> setLastDate(DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastActivityKey, dt.millisecondsSinceEpoch);
  }

  static Future<bool> wasActiveToday() async {
    if (sameDay(DateTime.now(), await getLastDate())) {
      return true;
    }
    return false;
  }
}