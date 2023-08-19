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

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateLevelId(int levelId) {
    state = state.copyWith(levelId: levelId);
  }

  void updateDifficulty(int difficulty) {
    state = state.copyWith(difficulty: difficulty);
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
    //print(enemiesCopy.map((e) => e.enemiesPos));
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
    if (state.enemiesPos.length - 1 == 0) {
      enemiesCopy.first.enemiesPos.clear();
      return;
    }
    enemiesCopy.removeLast();
    state = state.copyWith(enemiesPos: enemiesCopy);
  }

  void newWallsPos(int wall) {
    if (state.coinsPos.contains(wall)) {
      return;
    }
    final wallsCopy = () {
      if (state.wallsPos.contains(wall)) {
        return List<int>.from(state.wallsPos)..remove(wall);
      }
      return List<int>.from(state.wallsPos)..add(wall);
    }();
    state = state.copyWith(wallsPos: wallsCopy);
  }

  void newCoinsPos(int coin) {
    if (state.wallsPos.contains(coin)) {
      return;
    }
    final coinsCopy = () {
      if (state.coinsPos.contains(coin)) {
        return List<int>.from(state.coinsPos)..remove(coin);
      }
      return List<int>.from(state.coinsPos)..add(coin);
    }();
    state = state.copyWith(coinsPos: coinsCopy);
  }

  void updateFetching(bool value) {
    state = state.copyWith(fetching: value);
  }

  Future<bool> uploadLevel() async {
    updateFetching(true);
    final enemies = state.enemiesPos
        .where(
          (e) => e.enemiesPos.isNotEmpty,
        )
        .toList();
    final result = await levelsRepository.createLevel(
      LevelModel(
        id: '',
        level: levelsRepository.allLevels.length,
        difficulty: state.difficulty,
        name: state.name,
        coinsPos: state.coinsPos,
        enemies: enemies,
        finishPos: state.finishPos,
        playerPos: state.playerPos,
        wallsPos: state.wallsPos,
        creationDate: DateTime.now().toString(),
      ),
    );
    if (result) {
      levelsRepository.getLevels();
    }
    updateFetching(false);
    return result;
  }

  void clearAll() {
    state = state.copyWith(
      enemiesPos: [],
      coinsPos: [],
      wallsPos: [],
    );
  }
}
