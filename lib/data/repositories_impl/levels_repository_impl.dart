import 'package:cubetis/data/services/levels_service.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';

class LevelsRepositoryImpl implements LevelsRepository {
  LevelsRepositoryImpl(this.levelsService);

  final LevelsService levelsService;

  @override
  Future<LevelModel> getLevel(int levelId) async {
    return await levelsService.getLevel(levelId);
  }

  @override
  Future<bool> createLevel(LevelModel level) {
    // level = LevelModel(
    //   id: 0,
    //   name: 'eee',
    //   coinsPos: [],
    //   enemies: [
    //     EnemyModel(
    //       id: 0,
    //       enemiesPos: [4, 5],
    //       speed: 1,
    //     ),
    //   ],
    //   finishPos: 20,
    //   wallsPos: [],
    //   creationDate: DateTime.now().toString(),
    //   playerPos: defaultPlayerPos,
    // );
    return levelsService.createLevel(level);
  }

  @override
  List<LevelModel> get allLevels => levelsService.allLevels;
}
