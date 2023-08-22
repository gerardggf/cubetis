import 'package:cubetis/const/const.dart';
import 'package:cubetis/presentation/objects/coin.dart';
import 'package:cubetis/presentation/objects/empty.dart';
import 'package:cubetis/presentation/objects/enemy.dart';
import 'package:cubetis/presentation/objects/finish.dart';
import 'package:cubetis/presentation/objects/player.dart';
import 'package:cubetis/presentation/objects/wall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../objects/door.dart';
import '../../objects/door_key.dart';
import '../new_level/new_level_widget.dart';
import 'edit_level_controller.dart';

class EditLevelWidget extends ConsumerStatefulWidget {
  const EditLevelWidget({
    super.key,
    required this.canvasSize,
  });

  final Size? canvasSize;

  @override
  ConsumerState<EditLevelWidget> createState() => _EditLevelWidgetState();
}

class _EditLevelWidgetState extends ConsumerState<EditLevelWidget> {
  final int numCells = GameParams.columns * GameParams.rows;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(editLevelControllerProvider);
    final notifier = ref.watch(editLevelControllerProvider.notifier);

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
                    case 5:
                      notifier.newDoorPos(index);
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
                    } else if (controller.doors?.doorKeyPos.contains(index) ??
                        false) {
                      return const DoorKey();
                    } else if (controller.doors?.doorPos.contains(index) ??
                        false) {
                      return const Door();
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
              const Expanded(
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    controller.wallsPos.length.toString(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    controller.coinsPos.length.toString(),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
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
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${controller.doors?.doorPos.length.toString() ?? '0'} | ${controller.doors?.doorKeyPos.length.toString() ?? '0'}',
                  ),
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
                Container(
                  decoration: BoxDecoration(
                    border: controller.objectTypeSelector == 5
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
                      notifier.updateObjectTypeSelector(5);
                    },
                    child: notifier.isKeyPos ? const DoorKey() : const Door(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Builder(
            builder: (context) {
              switch (controller.objectTypeSelector) {
                case 0:
                  return Center(
                    child: Text(
                      controller.playerPos.toString(),
                    ),
                  );
                case 1:
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        controller.wallsPos.join(', '),
                      ),
                    ),
                  );
                case 2:
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        controller.coinsPos.join(', '),
                      ),
                    ),
                  );
                case 3:
                  return _buildEnemiesMenu();
                case 4:
                  return Center(
                    child: Text(
                      controller.finishPos.toString(),
                    ),
                  );
                case 5:
                  return _buildDoorsMenu();
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDoorsMenu() {
    final controller = ref.watch(editLevelControllerProvider);
    final notifier = ref.watch(editLevelControllerProvider.notifier);
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !notifier.isKeyPos ? Colors.blue : null,
                    ),
                    onPressed: () {
                      notifier.isKeyPos = false;
                      setState(() {});
                    },
                    child: const Text('Door'),
                  ),
                  Text(
                    controller.doors?.doorPos.join(', ') ?? '',
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: notifier.isKeyPos ? Colors.blue : null,
                    ),
                    onPressed: () {
                      notifier.isKeyPos = true;
                      setState(() {});
                    },
                    child: const Text('DoorKey'),
                  ),
                  Text(
                    controller.doors?.doorKeyPos.join(', ') ?? '',
                  ),
                ],
              ),
            ),
          ),
        ),
        if (controller.doors != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Duración:'),
                  DropdownButton<int>(
                    value: controller.doors?.timeInSeconds ??
                        GameParams.defaultDoorDuration,
                    onChanged: (value) {
                      notifier.updateDoorDuration(
                        value ?? GameParams.defaultDoorDuration,
                      );
                    },
                    items: [
                      for (var doorsSecondsOption in doorsSecondsOptions)
                        DropdownMenuItem<int>(
                          value: doorsSecondsOption,
                          child: Text(
                            '${doorsSecondsOption.toString()} seg.',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEnemiesMenu() {
    final controller = ref.watch(editLevelControllerProvider);
    final notifier = ref.watch(editLevelControllerProvider.notifier);

    return Row(
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
                    for (int i = 0; i < controller.enemiesPos.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 2,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: notifier.selectedEnemy == i
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
                      notifier.selectedEnemy = controller.enemiesPos.length;
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
    );
  }
}
