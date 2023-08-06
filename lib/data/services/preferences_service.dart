import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

final preferencesServiceProvider = Provider<PreferencesService>(
  (ref) => PreferencesService(
    ref.read(sharedPreferencesProvider),
  ),
);

class PreferencesService {
  PreferencesService(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
}
