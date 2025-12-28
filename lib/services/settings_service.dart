import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _horseRaceWinValueKey = 'horse_race_win_value';
  static const String _diceRollDelayKey = 'dice_roll_delay';

  Future<int> getHorseRaceWinValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_horseRaceWinValueKey) ?? 10;
  }

  Future<void> setHorseRaceWinValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_horseRaceWinValueKey, value);
  }

  Future<int> getDiceRollDelay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_diceRollDelayKey) ?? 1;
  }

  Future<void> setDiceRollDelay(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_diceRollDelayKey, value);
  }
}
