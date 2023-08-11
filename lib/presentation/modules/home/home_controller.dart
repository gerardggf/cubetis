import 'dart:async';

import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/home/state/home_state.dart';
import 'package:cubetis/const/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(
    HomeState(),
    ref.read(levelsRepositoryProvider),
  ),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController(
    super.state,
    this.levelsRepository,
  );

  final LevelsRepository levelsRepository;

  Timer? timer;

  void _updatePlayerPos(int newPos) {
    if (state.level == null) return;
    //tp from right to left when out of map
    if (newPos % GameParams.columns == 0 && newPos == state.playerPos + 1) {
      newPos -= GameParams.columns;
    }

    //tp from left to right when out of map
    if ((newPos + 1) % GameParams.columns == 0 &&
        newPos == state.playerPos - 1) {
      newPos += GameParams.columns;
    }

    //tp up to down when out of map
    if (newPos > (GameParams.rows * GameParams.columns)) {
      newPos -= GameParams.rows * GameParams.columns;
    }

    //tp down to up when out of map
    if (newPos.isNegative) {
      newPos += GameParams.rows * GameParams.columns;
    }

    //------------------------------------------------

    //counting points
    if (state.level!.coinsPos.contains(newPos) &&
        !state.points.contains(newPos)) {
      updatePoints(newPos);
    }

    //walls stopping player movement
    if (state.level!.wallsPos.contains(newPos) ||
        newPos < 0 ||
        newPos >= (GameParams.columns * GameParams.rows)) {
      return;
    }

    //hit by enemy
    if (state.enemiesPos.contains(newPos) ||
        state.enemiesPos.contains(state.playerPos)) {
      _hitByEnemy();
    }

    //finish level
    if (state.level!.finishPos == newPos &&
        state.points.length == state.level!.coinsPos.length) {
      loadLevel(state.level!.id + 1);
      clearPoints();
      if (kDebugMode) {
        print('Nivel ${state.level!.id + 1}');
      }
    }

    //update player pos
    state = state.copyWith(playerPos: newPos);
  }

  void updateEnemiesPos(List<int> enemiesPos) {
    state = state.copyWith(enemiesPos: enemiesPos);
  }

  void updatePlayerLives(int value) {
    state = state.copyWith(lives: value);
  }

  void updateIsPlaying(bool value) {
    state = state.copyWith(isPlaying: value);
  }

  Future<void> loadLevel(int levelId) async {
    final level = levelsRepository.allLevels[levelId];
    state = state.copyWith(playerPos: level.playerPos);
    state = state.copyWith(level: level);
    _updateCurrentEnemies();
  }

  //points -------------------------------

  void updatePoints(int points) {
    final allPoints = List<int>.from(state.points)..add(points);
    state = state.copyWith(points: allPoints);
  }

  void clearPoints() {
    state = state.copyWith(points: []);
  }

  //enemy ------------------------------------

  void _hitByEnemy() {
    updatePlayerLives(state.lives - 1);
    loadLevel(state.level!.id);
    clearPoints();
  }

  //-----------------------------------------

  void startGame() {
    if (state.level == null) return;
    updateIsPlaying(true);
  }

  void _updateCurrentEnemies() {
    timer?.cancel();
    updateEnemiesPos([]);
    final enemiesPos = state.level!.enemies
        .map(
          (e) => e.enemiesPos,
        )
        .toList();

    List<int> indexCounters = List.generate(enemiesPos.length, (index) => 0);
    List<int> currentEnemiesPos =
        List.generate(enemiesPos.length, (index) => 0);

    timer = Timer.periodic(
      const Duration(milliseconds: GameParams.enemyUpdateTime),
      (_) {
        for (var i = 0; i < enemiesPos.length; i++) {
          indexCounters[i]++;
          if (indexCounters[i] >= enemiesPos[i].length) {
            indexCounters[i] = 0;
          }
          currentEnemiesPos[i] = enemiesPos[i][indexCounters[i]];
        }

        updateEnemiesPos(currentEnemiesPos);

        if (currentEnemiesPos.contains(state.playerPos)) {
          _hitByEnemy();
        }
      },
    );
  }

  void endGame() {
    updateIsPlaying(false);
    timer?.cancel();
  }

  void onScreenTapDown({
    required TapDownDetails details,
    required Size? canvasSize,
  }) {
    if (canvasSize == null) {
      return;
    }
    if (!state.isPlaying) {
      // loadNivel();
      // initJuego();
    } else {
      final dx = details.localPosition.dx - (canvasSize.width / 2);
      final dy = details.localPosition.dy -
          ((canvasSize.width / GameParams.columns) * GameParams.rows / 2);
      // print('dx: $dx');
      // print('dy: $dy');

      //arriba
      if (dx > dy && -dx > dy) {
        _updatePlayerPos(state.playerPos - GameParams.columns);
      } //abajo
      else if (dx < dy && -dx < dy) {
        _updatePlayerPos(state.playerPos + GameParams.columns);
      } //izquierda
      else if (dx < dy && dx < -dy) {
        _updatePlayerPos(state.playerPos - 1);
      } //derecha
      else if (dx > dy && dx > -dy) {
        _updatePlayerPos(state.playerPos + 1);
      }
      // derrotado();
      // alLlegarMeta();
    }
  }

  void onButtonDown({
    required int direction,
    required Size? canvasSize,
  }) {
    if (canvasSize == null) {
      return;
    }
    if (!state.isPlaying) {
      // loadNivel();
      // initJuego();
    } else {
      //arriba
      if (direction == 0) {
        _updatePlayerPos(state.playerPos - GameParams.columns);
      } //abajo
      else if (direction == 1) {
        _updatePlayerPos(state.playerPos + GameParams.columns);
      } //izquierda
      else if (direction == 2) {
        _updatePlayerPos(state.playerPos - 1);
      } //derecha
      else if (direction == 3) {
        _updatePlayerPos(state.playerPos + 1);
      }
      // derrotado();
      // alLlegarMeta();
    }
  }
}
