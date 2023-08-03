import 'dart:async';

import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/home/state/home_state.dart';
import 'package:cubetis/const/const.dart';
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
    //tp from right to left when out of map
    if (newPos % kColumns == 0 && newPos > state.playerPos) {
      newPos -= kColumns;
    }

    //tp from left to right when out of map
    if ((newPos + 1) % kColumns == 0 && newPos < state.playerPos) {
      newPos += kColumns;
    }

    //adding points
    if (state.level!.coinsPos.contains(newPos) &&
        !state.points.contains(newPos)) {
      updatePoints(newPos);
    }

    //walls stopping player movement
    if (state.level!.wallsPos.contains(newPos) ||
        newPos < 0 ||
        newPos >= kRows * kColumns) {
      return;
    }

    state = state.copyWith(playerPos: newPos);
  }

  void updateEnemiesPos(List<int> enemiesPos) {
    state = state.copyWith(enemiesPos: enemiesPos);
  }

  void updateIsPlaying(bool value) {
    state = state.copyWith(isPlaying: value);
  }

  Future<void> loadLevel(int levelId) async {
    final level = await levelsRepository.getLevel(levelId);
    state = state.copyWith(level: level);
  }

  //points -------------------------------

  void updatePoints(int points) {
    final allPoints = List<int>.from(state.points)..add(points);
    state = state.copyWith(points: allPoints);
  }

  void clearPoints() {
    state = state.copyWith(points: []);
  }

  //-----------------------------------------

  Future<void> startGame() async {
    updateIsPlaying(true);

    final enemiesPos = state.level!.enemies
        .map(
          (e) => e.enemiesPos,
        )
        .toList();

    List<int> indexCounters = List.generate(enemiesPos.length, (index) => 0);
    List<int> currentEnemiesPos =
        List.generate(enemiesPos.length, (index) => 0);

    timer = Timer.periodic(
      const Duration(milliseconds: eTime),
      (_) {
        for (var i = 0; i < enemiesPos.length; i++) {
          indexCounters[i]++;
          if (indexCounters[i] >= enemiesPos[i].length) {
            indexCounters[i] = 0;
          }
          currentEnemiesPos[i] = enemiesPos[i][indexCounters[i]];
        }

        updateEnemiesPos(currentEnemiesPos);
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
          ((canvasSize.width / kColumns) * kRows / 2);
      // print('dx: $dx');
      // print('dy: $dy');

      //arriba
      if (dx > dy && -dx > dy) {
        _updatePlayerPos(state.playerPos - kColumns);
      } //abajo
      else if (dx < dy && -dx < dy) {
        _updatePlayerPos(state.playerPos + kColumns);
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
        _updatePlayerPos(state.playerPos - kColumns);
      } //abajo
      else if (direction == 1) {
        _updatePlayerPos(state.playerPos + kColumns);
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
