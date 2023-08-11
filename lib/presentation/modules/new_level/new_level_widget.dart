import 'package:cubetis/const/const.dart';
import 'package:cubetis/presentation/objects/coin.dart';
import 'package:cubetis/presentation/objects/empty.dart';
import 'package:cubetis/presentation/objects/enemy.dart';
import 'package:cubetis/presentation/objects/finish.dart';
import 'package:cubetis/presentation/objects/player.dart';
import 'package:cubetis/presentation/objects/wall.dart';
import 'package:cubetis/presentation/modules/new_level/new_level_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewLevelWidget extends ConsumerStatefulWidget {
  const NewLevelWidget({
    super.key,
    required this.canvasSize,
  });

  final Size? canvasSize;

  @override
  ConsumerState<NewLevelWidget> createState() => _NewLevelWidgetState();
}

class _NewLevelWidgetState extends ConsumerState<NewLevelWidget> {
  final int numCells = GameParams.columns * GameParams.rows;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newLevelControllerProvider);
    final notifier = ref.watch(newLevelControllerProvider.notifier);

    final double objectButtonSize = widget.canvasSize == null
        ? 0
        : widget.canvasSize!.width / GameParams.columns;

    return Column(
      children: [
        Container(
          color: Colors.black,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: numCells,
            itemBuilder: (BuildContext context, int index) {
              List<int> enemiesList = [];
              for (var i in controller.enemiesPos) {
                enemiesList.addAll(i.enemiesPos);
              }
              return GestureDetector(
                onTap: () {
                  switch (controller.objectTypeSelector) {
                    case 0:
                      notifier.newPlayerPos(index);
                      break;
                    case 1:
                      notifier.newWallsPos(index);
                      break;
                    case 2:
                      notifier.newCoinsPos(index);
                      break;
                    case 3:
                      notifier.newEnemiesPos(index);
                      break;
                    case 4:
                      notifier.newFinishPos(index);
                      break;
                  }
                },
                child: Builder(
                  builder: (_) {
                    if (controller.playerPos == index) {
                      return const Player();
                    } else if (enemiesList.contains(index) &&
                        controller.wallsPos.contains(index)) {
                      return Wall(
                        isInEnemyPath: true,
                        enemyIndex: controller.enemiesPos
                            .map(
                              (e) => e.enemiesPos.indexOf(index) + 1,
                            )
                            .toList(),
                      );
                    } else if (enemiesList.contains(index)) {
                      return Enemy(
                        enemyIndex: controller.enemiesPos
                            .map(
                              (e) => e.enemiesPos.indexOf(index) + 1,
                            )
                            .toList(),
                      );
                    } else if (controller.wallsPos.contains(index)) {
                      return const Wall();
                    } else if (controller.coinsPos.contains(index)) {
                      return const Coin();
                    } else if (controller.finishPos == index) {
                      return const Finish();
                    } else {
                      return Empty(
                        index: index,
                      );
                    }
                  },
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GameParams.columns,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                child: Text(
                  '1',
                ),
              ),
              SizedBox(
                child: Text(
                  controller.wallsPos.length.toString(),
                ),
              ),
              SizedBox(
                child: Text(
                  controller.coinsPos.length.toString(),
                ),
              ),
              SizedBox(
                child: Text(
                  controller.enemiesPos.isNotEmpty
                      ? controller.enemiesPos
                          .map(
                            (e) => e.enemiesPos.length,
                          )
                          .toList()
                          .join('|')
                      : '0',
                ),
              ),
              const SizedBox(
                child: Text(
                  '1',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: controller.objectTypeSelector == 0
                        ? Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Colors.yellow,
                            width: 3,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: objectButtonSize,
                  height: objectButtonSize,
                  child: InkWell(
                    onTap: () {
                      notifier.updateObjectTypeSelector(0);
                    },
                    child: const Player(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: controller.objectTypeSelector == 1
                        ? Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Colors.yellow,
                            width: 3,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: objectButtonSize,
                  height: objectButtonSize,
                  child: InkWell(
                    onTap: () {
                      notifier.updateObjectTypeSelector(1);
                    },
                    child: const Wall(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: controller.objectTypeSelector == 2
                        ? Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Colors.yellow,
                            width: 3,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: objectButtonSize,
                  height: objectButtonSize,
                  child: InkWell(
                    onTap: () {
                      notifier.updateObjectTypeSelector(2);
                    },
                    child: const Coin(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: controller.objectTypeSelector == 3
                        ? Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Colors.yellow,
                            width: 3,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: objectButtonSize,
                  height: objectButtonSize,
                  child: InkWell(
                    onTap: () {
                      if (controller.enemiesPos.isEmpty) {
                        notifier.addEnemy();
                      }
                      notifier.updateObjectTypeSelector(3);
                    },
                    child: const Enemy(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: controller.objectTypeSelector == 4
                        ? Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Colors.yellow,
                            width: 3,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: objectButtonSize,
                  height: objectButtonSize,
                  child: InkWell(
                    onTap: () {
                      notifier.updateObjectTypeSelector(4);
                    },
                    child: const Finish(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: controller.objectTypeSelector == 3
              ? Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          const Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text('Selecciona al enemigo'),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (int i = 0;
                                    i < controller.enemiesPos.length;
                                    i++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 2,
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            notifier.selectedEnemy == i
                                                ? Colors.blue
                                                : null,
                                      ),
                                      onPressed: () {
                                        notifier.selectedEnemy = i;
                                        setState(() {});
                                      },
                                      child: Text(
                                        controller.enemiesPos[i].id.toString(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                notifier.addEnemy();
                                setState(() {
                                  notifier.selectedEnemy =
                                      controller.enemiesPos.length;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                if (controller.enemiesPos.length - 1 == 0) {
                                  return;
                                }
                                notifier.deleteLastEnemy();
                                setState(() {
                                  notifier.selectedEnemy = 0;
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
