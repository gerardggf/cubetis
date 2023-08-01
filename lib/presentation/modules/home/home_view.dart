import 'dart:async';

import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/modules/home/objects/empty.dart';
import 'package:cubetis/presentation/modules/home/objects/enemy.dart';
import 'package:cubetis/presentation/modules/home/objects/jugador.dart';
import 'package:cubetis/presentation/modules/home/objects/finish.dart';
import 'package:cubetis/presentation/modules/home/objects/coin.dart';
import 'package:cubetis/presentation/modules/home/objects/wall.dart';
import 'package:cubetis/presentation/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Size? canvasSize;
  Timer? timer;

  final int numCells = kColumns * kRows;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        canvasSize = MediaQuery.of(context).size;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    final notifier = ref.watch(homeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cubetis',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: canvasSize == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : controller.level == null
              ? Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await notifier.loadLevel(0);
                      await startGame();
                    },
                    child: const Text('Start game'),
                  ),
                )
              : Column(
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        _onTapDown(details);
                      },
                      child: Container(
                        color: Colors.black,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: numCells,
                          itemBuilder: (BuildContext context, int index) {
                            List<int> enemiesList = [];
                            for (var i in controller.level!.enemies) {
                              enemiesList.addAll(i.enemiesPos);
                            }
                            if (controller.playerPos == index) {
                              return const Player();
                            } else if (enemiesList.contains(index) &&
                                controller.level!.wallsPos.contains(index)) {
                              return const Wall(
                                isInEnemyPath: true,
                              );
                            } else if (controller.enemiesPos.contains(index)) {
                              return const Enemy();
                            } else if (controller.level!.wallsPos
                                .contains(index)) {
                              return const Wall();
                            } else if (controller.level!.coinsPos
                                .contains(index)) {
                              return const Coin();
                            } else if (controller.level!.finishPos == index) {
                              return const Finish();
                            } else {
                              return Empty(
                                index: index,
                              );
                            }
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: kColumns,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text('wip'),
                    ),
                  ],
                ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    final controller = ref.read(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);
    if (canvasSize == null) {
      return;
    }
    if (!controller.isPlaying) {
      // loadNivel();
      // initJuego();
    } else {
      final dx = details.localPosition.dx - (canvasSize!.width / 2);
      final dy = details.localPosition.dy -
          ((canvasSize!.width / kColumns) * kRows / 2);
      // print('dx: $dx');
      // print('dy: $dy');

      //arriba
      if (dx > dy && -dx > dy) {
        notifier.updatePlayerPos(controller.playerPos - kColumns);
      } //abajo
      else if (dx < dy && -dx < dy) {
        notifier.updatePlayerPos(controller.playerPos + kColumns);
      } //izquierda
      else if (dx < dy && dx < -dy) {
        notifier.updatePlayerPos(controller.playerPos - 1);
      } //derecha
      else if (dx > dy && dx > -dy) {
        notifier.updatePlayerPos(controller.playerPos + 1);
      }
      // derrotado();
      // alLlegarMeta();
    }
  }

  Future<void> startGame() async {
    //final controller = ref.read(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);

    notifier.updateIsPlaying(true);

    //final enemies = controller.level!.enemies.map((e) => e.enemiesPos).toList();

    //List<int> indexCounters = List.generate(enemies.length, (index) => 0);
    // timer = Timer.periodic(
    //   const Duration(milliseconds: eTime),
    //   (_) {
    //     List<int> currentEnemiesPos = [];
    //     for (var enemy in enemies) {
    //       for (var i = 0; i < enemy.length; i++) {
    //         if (enemy.length == indexCounters[enemies.indexOf(enemy)]) {
    //           indexCounters[enemies.indexOf(enemy)] = 0;
    //         } else {
    //           indexCounters[enemies.indexOf(enemy)]++;
    //         }
    //         currentEnemiesPos[enemies.indexOf(enemy)]=indexCounters;
    //       }
    //     }

    //     notifier.updateEnemiesPos(currentEnemiesPos);
    //   },
    // );
  }

  void endGame() {
    final notifier = ref.read(homeControllerProvider.notifier);
    notifier.updateIsPlaying(false);
    timer?.cancel();
  }
}
