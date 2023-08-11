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
    await sharedPreferences.setInt(
      Preferences.level.name,
      level,
    );
  }
}
