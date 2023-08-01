import 'package:cubetis/data/repositories_impl/levels_repository_impl.dart';
import 'package:cubetis/data/services/levels_service.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelsRepositoryProvider = Provider<LevelsRepository>(
  (ref) => LevelsRepositoryImpl(
    ref.read(levelsServiceProvider),
  ),
);

abstract class LevelsRepository {
  Future<LevelModel> getLevel(int levelId);
  Future<bool> createLevel(LevelModel level);
}
