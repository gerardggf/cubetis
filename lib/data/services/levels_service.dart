import 'dart:convert';
import 'dart:developer';

import 'package:cubetis/domain/models/all_levels_model.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelsServiceProvider = Provider<LevelsService>(
  (ref) => LevelsService(),
);

class LevelsService {
  List<LevelModel> _allLevels = [];

  List<LevelModel> get allLevels => _allLevels;

  Future<LevelModel> getLevel(int levelId) async {
    try {
      if (allLevels.isEmpty) {
        await getAllLevels();
      }
      return allLevels[levelId];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return allLevels.last;
    }
  }

  Future<bool> createLevel(LevelModel level) async {
    try {
      _allLevels.add(level);
      log(jsonEncode(level));
    } catch (e) {
      if (kDebugMode) {
        print(
          e.toString(),
        );
      }
    }
    return false;
  }

  Future<List<LevelModel>> getAllLevels() async {
    final String response =
        await rootBundle.loadString('assets/json/levels.json');
    final result = AllLevelsModel.fromJson(json.decode(response)).levels;
    _allLevels = result;
    return _allLevels;
  }
}
