import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/new_level/state/new_level_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newLevelControllerProvider =
    StateNotifierProvider<NewLevelController, NewLevelState>(
  (ref) => NewLevelController(
    NewLevelState(),
    ref.read(levelsRepositoryProvider),
  ),
);

class NewLevelController extends StateNotifier<NewLevelState> {
  NewLevelController(
    super.state,
    this.levelsRepository,
  );

  final LevelsRepository levelsRepository;

  int enemiesCounter = 0;

  void updateObjectTypeSelector(int value) {
    state = state.copyWith(objectTypeSelector: value);
  }

  void newPlayerPos(int player) {
    state = state.copyWith(playerPos: player);
  }

  void newFinishPos(int finish) {
    state = state.copyWith(finishPos: finish);
  }

  void newEnemiesPos(int enemy) {
    final enemyPosCopy = () {
      if (state.enemiesPos.isNotEmpty) {
        if (state.enemiesPos.first.enemiesPos.contains(enemy)) {
          return List<int>.from(state.enemiesPos.first.enemiesPos)
            ..remove(enemy);
        }

        return List<int>.from(state.enemiesPos.first.enemiesPos)..add(enemy);
      } else {
        return [enemy];
      }
    }();
    final enemiesCopy = [
      EnemyModel(
        id: 0,
        enemiesPos: enemyPosCopy,
        speed: 1,
      ),
    ];
    state = state.copyWith(enemiesPos: enemiesCopy);
  }

  void newWallsPos(int wall) {
    final wallsCopy = () {
      if (state.wallsPos.contains(wall)) {
        return List<int>.from(state.wallsPos)..remove(wall);
      }
      return List<int>.from(state.wallsPos)..add(wall);
    }();
    state = state.copyWith(wallsPos: wallsCopy);
  }

  void newCoinsPos(int coin) {
    final coinsCopy = () {
      if (state.coinsPos.contains(coin)) {
        return List<int>.from(state.coinsPos)..remove(coin);
      }
      return List<int>.from(state.coinsPos)..add(coin);
    }();
    state = state.copyWith(coinsPos: coinsCopy);
  }

  void uploadLevel() {
    levelsRepository.createLevel(
      LevelModel(
        id: levelsRepository.allLevels.length,
        name: state.name,
        coinsPos: state.coinsPos,
        enemies: state.enemiesPos,
        finishPos: state.finishPos,
        playerPos: state.playerPos,
        wallsPos: state.wallsPos,
        creationDate: DateTime.now().toString(),
      ),
    );
  }

  void clearAll() {
    state = state.copyWith(
      enemiesPos: [],
      coinsPos: [],
      wallsPos: [],
    );
  }
}
