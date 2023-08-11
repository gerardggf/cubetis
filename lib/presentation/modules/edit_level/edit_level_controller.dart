import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/edit_level_state.dart';

final editLevelControllerProvider =
    StateNotifierProvider<EditLevelController, EditLevelState>(
  (ref) => EditLevelController(
    EditLevelState(),
    ref.read(levelsRepositoryProvider),
  ),
);

class EditLevelController extends StateNotifier<EditLevelState> {
  EditLevelController(
    super.state,
    this.levelsRepository,
  );

  final LevelsRepository levelsRepository;

  int selectedEnemy = 0;

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
        if (state.enemiesPos[selectedEnemy].enemiesPos.contains(enemy)) {
          return List<int>.from(state.enemiesPos[selectedEnemy].enemiesPos)
            ..remove(enemy);
        }

        return List<int>.from(state.enemiesPos[selectedEnemy].enemiesPos)
          ..add(enemy);
      } else {
        return [enemy];
      }
    }();
    List<EnemyModel> enemiesCopy = List.generate(
      state.enemiesPos.length,
      (index) => state.enemiesPos[index],
    );
    enemiesCopy.removeAt(selectedEnemy);
    enemiesCopy.insert(
      selectedEnemy,
      EnemyModel(
        id: selectedEnemy,
        enemiesPos: enemyPosCopy,
        speed: 1,
      ),
    );
    print(enemiesCopy.map((e) => e.enemiesPos));
    state = state.copyWith(enemiesPos: enemiesCopy);
  }

  void addEnemy() {
    if (state.enemiesPos.length > 10) {
      return;
    }
    final enemiesCopy = List.generate(
      state.enemiesPos.length,
      (index) => state.enemiesPos[index],
    );

    enemiesCopy.add(
      EnemyModel(
        id: state.enemiesPos.length,
        enemiesPos: [],
        speed: 1,
      ),
    );
    state = state.copyWith(enemiesPos: enemiesCopy);
  }

  void deleteLastEnemy() {
    final enemiesCopy = List.generate(
      state.enemiesPos.length,
      (index) => state.enemiesPos[index],
    );
    enemiesCopy.removeLast();
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

  Future<bool> updateLevel() async {
    final result = await levelsRepository.createLevel(
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
    if (result) {
      levelsRepository.getLevels();
    }
    return result;
  }

  void clearAll() {
    state = state.copyWith(
      enemiesPos: [],
      coinsPos: [],
      wallsPos: [],
    );
  }

  Future<void> loadLevelToUpdate(int level) async {
    final editLevel = levelsRepository.allLevels[level];
    state = state.copyWith(
      coinsPos: editLevel.coinsPos,
      enemiesPos: editLevel.enemies,
      wallsPos: editLevel.wallsPos,
      playerPos: editLevel.playerPos,
      finishPos: editLevel.finishPos,
    );
  }
}