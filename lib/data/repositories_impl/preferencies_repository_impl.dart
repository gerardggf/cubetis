import 'package:cubetis/const/const.dart';
import 'package:cubetis/domain/enums.dart';
import 'package:cubetis/domain/repositories/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  PreferencesRepositoryImpl({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  String get levelId =>
      sharedPreferences.getString(Preferences.level.name) ?? kFirstLevelId;

  @override
  Future<void> setLevel(String levelId) async {
    await sharedPreferences.setString(
      Preferences.level.name,
      levelId,
    );
  }

  // @override
  // String get maxLevelId => sharedPreferences.getString(Preferences.maxLevel.name) ?? '';

  // @override
  // Future<void> setMaxLevel(String maxLevelId) async {
  //   await sharedPreferences.setString(
  //     Preferences.maxLevel.name,
  //     maxLevelId,
  //   );
  // }

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

  @override
  int get lives =>
      sharedPreferences.getInt(Preferences.lives.name) ?? GameParams.lives;

  @override
  Future<void> setLives(int lives) async {
    await sharedPreferences.setInt(
      Preferences.lives.name,
      lives,
    );
  }
}
