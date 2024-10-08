import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../const/const.dart';
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

  LevelModel? editingLevel;

  int selectedEnemy = 0;
  bool isKeyPos = false;

  void updateObjectTypeSelector(int value) {
    state = state.copyWith(objectTypeSelector: value);
  }

  void newPlayerPos(int player) {
    state = state.copyWith(playerPos: player);
  }

  void newFinishPos(int finish) {
    state = state.copyWith(finishPos: finish);
  }

  void updateName(String text) {
    state = state.copyWith(name: text);
  }

  void updateDifficulty(int value) {
    state = state.copyWith(difficulty: value);
  }

  void newDoorPos(int doorPos) {
    if (state.wallsPos.contains(doorPos) || state.coinsPos.contains(doorPos)) {
      return;
    }
    if (isKeyPos) {
      List<int> doorKeyCopy = state.doors != null
          ? List.generate(
              state.doors!.doorKeyPos.length,
              (index) => state.doors!.doorKeyPos[index],
            )
          : [];
      if (doorKeyCopy.contains(doorPos)) {
        doorKeyCopy.remove(doorPos);
      } else {
        if (state.doors?.doorPos.contains(doorPos) ?? false) {
          return;
        }
        doorKeyCopy.add(doorPos);
      }

      state = state.copyWith(
        doors: DoorModel(
          doorKeyPos: doorKeyCopy,
          doorPos: state.doors?.doorPos ?? [],
          timeInSeconds: state.doors?.timeInSeconds ??
              state.doors?.timeInSeconds ??
              GameParams.defaultDoorDuration,
        ),
      );
      //print(state.doors?.doorPos);
    } else {
      List<int> doorCopy = state.doors != null
          ? List.generate(
              state.doors!.doorPos.length,
              (index) => state.doors!.doorPos[index],
            )
          : [];
      if (doorCopy.contains(doorPos)) {
        doorCopy.remove(doorPos);
      } else {
        if (state.doors?.doorKeyPos.contains(doorPos) ?? false) {
          return;
        }
        doorCopy.add(doorPos);
      }
      state = state.copyWith(
        doors: DoorModel(
          doorKeyPos: state.doors?.doorKeyPos ?? [],
          doorPos: doorCopy,
          timeInSeconds: state.doors?.timeInSeconds ??
              state.doors?.timeInSeconds ??
              GameParams.defaultDoorDuration,
        ),
      );
      //print(state.doors?.doorKeyPos);
    }
  }

  void updateDoorDuration(int seconds) {
    state = state.copyWith(
      doors: DoorModel(
        doorKeyPos: state.doors?.doorKeyPos ?? [],
        doorPos: state.doors?.doorPos ?? [],
        timeInSeconds: seconds,
      ),
    );
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
    if (state.enemiesPos.length > GameParams.maxEnemies) {
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

  Future<bool> updateLevel({bool isUserLevel = true}) async {
    updateFetching(true);
    final levelId = editingLevel?.id;
    if (levelId == null) {
      updateFetching(false);
      return false;
    }

    final result = await levelsRepository.updateLevel(
      isUserLevel: isUserLevel,
      id: levelId,
      level: LevelModel(
        id: levelId,
        authorId: state.authorId,
        difficulty: state.difficulty,
        name: state.name,
        coinsPos: state.coinsPos,
        enemies: state.enemiesPos,
        finishPos: state.finishPos,
        playerPos: state.playerPos,
        wallsPos: state.wallsPos,
        doors: state.doors,
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
      enemiesPos: [
        EnemyModel(
          id: 0,
          enemiesPos: [],
          speed: 1,
        ),
      ],
      coinsPos: [],
      wallsPos: [],
      doors: null,
    );
  }

  Future<void> loadLevelToUpdate(String id) async {
    try {
      editingLevel = levelsRepository.allLevels.firstWhere((e) => e.id == id);
    } catch (_) {
      editingLevel = await levelsRepository.getUserLevel(id);
    }
    if (editingLevel == null) return;
    state = state.copyWith(
      coinsPos: editingLevel!.coinsPos,
      enemiesPos: editingLevel!.enemies,
      wallsPos: editingLevel!.wallsPos,
      playerPos: editingLevel!.playerPos,
      finishPos: editingLevel!.finishPos,
      doors: editingLevel!.doors,
      name: editingLevel!.name,
      difficulty: editingLevel!.difficulty,
      authorId: editingLevel!.authorId,
    );
  }
}
