import 'package:cubetis/const/const.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/objects/coin.dart';
import 'package:cubetis/presentation/objects/empty.dart';
import 'package:cubetis/presentation/objects/enemy.dart';
import 'package:cubetis/presentation/objects/finish.dart';
import 'package:cubetis/presentation/objects/jugador.dart';
import 'package:cubetis/presentation/objects/wall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameWidget extends ConsumerStatefulWidget {
  const GameWidget({
    super.key,
    required this.canvasSize,
  });

  final Size? canvasSize;

  @override
  ConsumerState<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends ConsumerState<GameWidget> {
  final int numCells = kColumns * kRows;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    final notifier = ref.watch(homeControllerProvider.notifier);

    return Column(
      children: [
        GestureDetector(
          onTapDown: (details) {
            notifier.onScreenTapDown(
              details: details,
              canvasSize: widget.canvasSize,
            );
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
                } else if (controller.level!.wallsPos.contains(index)) {
                  return const Wall();
                } else if (controller.level!.coinsPos.contains(index) &&
                    !controller.points.contains(index)) {
                  return const Coin();
                } else if (controller.level!.finishPos == index) {
                  return const Finish();
                } else {
                  return const Empty(
                      //index: index,
                      );
                }
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kColumns,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.yellow,
                child: Column(
                  children: [
                    const Text('Points'),
                    Text(
                      controller.points.length.toString(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.orange,
                child: const Column(
                  children: [
                    Text('Lifes'),
                    Text(
                      '1',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: _buildButtonControl(notifier),
        ),
      ],
    );
  }

  Widget _buildButtonControl(HomeController notifier) => Row(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.onButtonDown(
                          direction: 0,
                          canvasSize: widget.canvasSize,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: kColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.arrow_drop_up,
                            size: kBtnSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.onButtonDown(
                          direction: 2,
                          canvasSize: widget.canvasSize,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: kColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.arrow_left,
                            size: kBtnSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.onButtonDown(
                          direction: 3,
                          canvasSize: widget.canvasSize,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: kColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.arrow_right,
                            size: kBtnSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.onButtonDown(
                          direction: 1,
                          canvasSize: widget.canvasSize,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: kColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.arrow_drop_down,
                            size: kBtnSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      );
}
