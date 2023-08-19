import 'package:cubetis/domain/enums.dart';
import 'package:cubetis/domain/repositories/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  PreferencesRepositoryImpl({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  int get level => sharedPreferences.getInt(Preferences.level.name) ?? 0;

  @override
  Future<void> setLevel(int level) async {
    if (level >= maxLevel) {
      setMaxLevel(level);
    }
    await sharedPreferences.setInt(
      Preferences.level.name,
      level,
    );
  }

  @override
  int get maxLevel => sharedPreferences.getInt(Preferences.maxLevel.name) ?? 0;

  @override
  Future<void> setMaxLevel(int maxLevel) async {
    await sharedPreferences.setInt(
      Preferences.maxLevel.name,
      level,
    );
  }

  @override
  int get timeInSeconds =>
      sharedPreferences.getInt(Preferences.timeInSeconds.name) ?? 0;

  @override
  Future<void> setTimeInSeconds(int timeInSeconds) async {
    await sharedPreferences.setInt(
      Preferences.timeInSeconds.name,
      timeInSeconds,
    );
  }
}
