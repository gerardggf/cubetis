import 'package:cubetis/const/const.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/levels/levels_controller.dart';
import 'package:cubetis/presentation/modules/levels/state/levels_state.dart';
import 'package:cubetis/presentation/modules/new_level/state/new_level_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newLevelControllerProvider =
    StateNotifierProvider<NewLevelController, NewLevelState>(
  (ref) => NewLevelController(
    NewLevelState(),
    ref.read(levelsRepositoryProvider),
    ref.read(levelsControllerProvider),
  ),
);

class NewLevelController extends StateNotifier<NewLevelState> {
  NewLevelController(
    super.state,
    this.levelsRepository,
    this.levelsController,
  );

  final LevelsRepository levelsRepository;
  final LevelsState levelsController;

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

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDifficulty(int difficulty) {
    state = state.copyWith(difficulty: difficulty);
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
          timeInSeconds:
              state.doors?.timeInSeconds ?? GameParams.defaultDoorDuration,
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
          timeInSeconds:
              state.doors?.timeInSeconds ?? GameParams.defaultDoorDuration,
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

  Future<bool> uploadLevel({
    bool isUserLevel = true,
  }) async {
    updateFetching(true);
    final enemies = state.enemiesPos
        .where(
          (e) => e.enemiesPos.isNotEmpty,
        )
        .toList();

    final result = await levelsRepository.createLevel(
      level: LevelModel(
        id: '',
        //sustituir prueba por id de usuario
        authorId: isUserLevel ? 'Prueba' : '',
        difficulty: state.difficulty,
        name: state.name[0].toUpperCase() + state.name.substring(1),
        coinsPos: state.coinsPos,
        enemies: enemies,
        finishPos: state.finishPos,
        playerPos: state.playerPos,
        wallsPos: state.wallsPos,
        doors: state.doors,
        creationDate: DateTime.now().toString(),
      ),
      isUserLevel: isUserLevel,
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
    selectedEnemy = 0;
  }
}
