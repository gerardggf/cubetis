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

  final numPixels = kColumns * kRows;

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
                    onPressed: () {
                      startGame();
                    },
                    child: const Text('Start game'),
                  ),
                )
              : GestureDetector(
                  onTapDown: (details) {
                    _onTapDown(details);
                  },
                  child: Column(
                    children: [
                      Container(
                        color: Colors.black,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: numPixels,
                          itemBuilder: (BuildContext context, int index) {
                            final List<int> enemiesList = []..expand(
                                (_) => controller.level!.enemies
                                    .map((e) => e.enemiesPos)
                                    .toList(),
                              );
                            //pintar píxeles
                            if (controller.playerPos == index) {
                              return const Player();
                            } else if (enemiesList.contains(index) &&
                                controller.level!.wallsPos.contains(index)) {
                              return const Wall(
                                isInEnemyPath: true,
                              );
                            } else if (enemiesList.contains(index)) {
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
                              return const Empty();
                            }
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: kRows,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text('wip'),
                      ),
                    ],
                  ),
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
      print(details.localPosition);
      //---------------------------------------------------------------------------------------------
      //arriba
      if (details.localPosition.dx < details.localPosition.dy &&
          -details.localPosition.dx < details.localPosition.dy) {
        notifier.updatePlayerPos(controller.playerPos - kRows);
        print('arriba');
      } //abajo
      else if (details.localPosition.dx > details.localPosition.dy &&
          -details.localPosition.dx > details.localPosition.dy) {
        notifier.updatePlayerPos(controller.playerPos + kRows);
        print('abajo');
      } //izquierda
      else if (details.localPosition.dx < details.localPosition.dy &&
          details.localPosition.dx < -details.localPosition.dy) {
        notifier.updatePlayerPos(controller.playerPos + 1);
        print('izquierda');
      } //derecha
      else if (details.localPosition.dx > details.localPosition.dy &&
          details.localPosition.dx > -details.localPosition.dy) {
        notifier.updatePlayerPos(controller.playerPos - 1);
        print('derecha');
      }
      //---------------------------------------------------------------------------------------------

      // derrotado();
      // alLlegarMeta();
    }
  }

  void startGame() {
    final notifier = ref.read(homeControllerProvider.notifier);
    notifier.loadLevel(0);
    notifier.updateIsPlaying(true);
  }
}
