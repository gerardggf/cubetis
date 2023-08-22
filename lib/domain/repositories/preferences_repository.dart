import 'package:cubetis/data/repositories_impl/preferencies_repository_impl.dart';
import 'package:cubetis/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => PreferencesRepositoryImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
  ),
);

abstract class PreferencesRepository {
  Future<void> setLevel(String levelId);
  String get levelId;
  // Future<void> setMaxLevel(String maxLevelId);
  // String get maxLevelId;
  Future<void> setLives(int lives);
  int get lives;
  Future<void> setTimeInSeconds(int timeInSeconds);
  int get timeInSeconds;
}
