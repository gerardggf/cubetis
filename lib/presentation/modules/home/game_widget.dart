import 'package:cubetis/const/const.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/modules/home/objects/coin.dart';
import 'package:cubetis/presentation/modules/home/objects/empty.dart';
import 'package:cubetis/presentation/modules/home/objects/enemy.dart';
import 'package:cubetis/presentation/modules/home/objects/finish.dart';
import 'package:cubetis/presentation/modules/home/objects/jugador.dart';
import 'package:cubetis/presentation/modules/home/objects/wall.dart';
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
    return Column(
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
                } else if (controller.level!.wallsPos.contains(index)) {
                  return const Wall();
                } else if (controller.level!.coinsPos.contains(index)) {
                  return const Coin();
                } else if (controller.level!.finishPos == index) {
                  return const Finish();
                } else {
                  return Empty(
                    index: index,
                  );
                }
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kColumns,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Text('wip'),
        ),
      ],
    );
  }

  void _onTapDown(TapDownDetails details) {
    final controller = ref.read(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);
    if (widget.canvasSize == null) {
      return;
    }
    if (!controller.isPlaying) {
      // loadNivel();
      // initJuego();
    } else {
      final dx = details.localPosition.dx - (widget.canvasSize!.width / 2);
      final dy = details.localPosition.dy -
          ((widget.canvasSize!.width / kColumns) * kRows / 2);
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
}
