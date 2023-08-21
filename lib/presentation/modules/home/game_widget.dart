import 'package:cubetis/const/const.dart';
import 'package:cubetis/domain/repositories/preferences_repository.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/objects/coin.dart';
import 'package:cubetis/presentation/objects/door.dart';
import 'package:cubetis/presentation/objects/door_key.dart';
import 'package:cubetis/presentation/objects/empty.dart';
import 'package:cubetis/presentation/objects/enemy.dart';
import 'package:cubetis/presentation/objects/finish.dart';
import 'package:cubetis/presentation/objects/player.dart';
import 'package:cubetis/presentation/objects/wall.dart';
import 'package:cubetis/presentation/utils/date_time_conversions.dart';
import 'package:cubetis/presentation/utils/dialogs/show_warning_dialog.dart';
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
  final int numCells = GameParams.columns * GameParams.rows;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    final notifier = ref.watch(homeControllerProvider.notifier);

    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            if (controller.isPlaying) {
              notifier.updateIsPlaying(false);
              return;
            }
          },
          onTapDown: (details) {
            notifier.onScreenTapDown(
              details: details,
              canvasSize: widget.canvasSize,
            );
          },
          child: Container(
            color: Colors.black,
            child: controller.level == null || !controller.isPlaying
                ? _buildPausedScreen()
                : GridView.builder(
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
                      } else if (controller.enemiesPos.contains(index)) {
                        return const Enemy();
                      } else if (enemiesList.contains(index) &&
                          controller.level!.wallsPos.contains(index)) {
                        return const Wall(
                          isInEnemyPath: true,
                        );
                      } else if (controller.level!.wallsPos.contains(index)) {
                        return const Wall();
                      } else if ((controller.level!.doors?.doorPos
                                  .contains(index) ??
                              false) &&
                          !controller.doorsOpen) {
                        return const Door();
                      } else if (controller.level!.doors?.doorKeyPos
                              .contains(index) ??
                          false) {
                        return DoorKey(
                          seconds: controller.level!.doors!.timeInSeconds,
                        );
                      } else if (controller.level!.coinsPos.contains(index) &&
                          !controller.points.contains(index)) {
                        return const Coin();
                      } else if (controller.level!.finishPos == index) {
                        return Finish(
                          color: controller.points.length ==
                                  controller.level!.coinsPos.length
                              ? Colors.white
                              : Colors.white24,
                        );
                      } else {
                        return const Empty();
                      }
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: GameParams.columns,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildDataItem(
                        firstWidget: const AspectRatio(
                          aspectRatio: 1,
                          child: Coin(),
                        ),
                        data: controller.points.length.toString(),
                      ),
                    ),
                    Expanded(
                      child: _buildDataItem(
                          firstWidget: const Icon(Icons.timer_outlined),
                          data: secondsToTime(controller.gameTimerInSeconds),
                          onPressed: () {
                            if (controller.isPlaying) {
                              notifier.updateIsPlaying(false);
                              return;
                            }
                          }),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: _buildPadControl(), //_buildButtonControl(notifier),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildDataItem(
                        firstWidget: const AspectRatio(
                          aspectRatio: 1,
                          child: Player(),
                        ),
                        data: controller.lives.toString(),
                      ),
                    ),
                    Expanded(
                      child: _buildDataItem(
                        firstWidget: const Icon(Icons.restore),
                        data: 'Reset',
                        onPressed: () {
                          showCustomWarningDialog(
                            context: context,
                            title: 'Reiniciar niveles',
                            content:
                                '¿Quieres reiniciar todos los parámetros y los niveles?',
                            onPressedConfirm: () {
                              Navigator.pop(context);
                              notifier.restartFromZero();
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataItem({
    required Widget firstWidget,
    required String data,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: firstWidget,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                data,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPadControl() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            final notifier = ref.watch(homeControllerProvider.notifier);
            notifier.onButtonDown(
              direction: _sendPadInfo(
                details,
                Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                ),
              ),
              canvasSize: widget.canvasSize,
            );
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: XPainter(),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      _buildArrowIcon(Icons.arrow_drop_up),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildArrowIcon(Icons.arrow_left),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      _buildArrowIcon(Icons.arrow_right),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      _buildArrowIcon(Icons.arrow_drop_down),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArrowIcon(IconData icon) => Expanded(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Icon(
            icon,
            color: Colors.grey,
          ),
        ),
      );

  Widget _buildPausedScreen() {
    final notifier = ref.watch(homeControllerProvider.notifier);
    return Stack(
      children: [
        GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GameParams.columns,
            ),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: numCells,
            itemBuilder: (BuildContext context, int index) {
              if (index == 33) {
                return const Player();
              }
              if ([11, 12, 13, 21, 31, 41, 51, 61, 58, 68, 78, 88, 98, 97, 96]
                  .contains(index)) {
                return const Wall();
              }
              if (index == 92) {
                return const Finish();
              }
              if (index == 94) {
                return const Coin();
              }
              if (index == 36) {
                return const Enemy();
              }
              return const Empty();
            }),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          right: 0,
          child: TextButton(
            onPressed: () async {
              await notifier
                  .loadLevel(ref.read(preferencesRepositoryProvider).level);

              notifier.startGame();
            },
            child: const Text(
              'CUBETIS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 80,
          bottom: 0,
          right: 0,
          child: TextButton(
            onPressed: () async {
              await notifier
                  .loadLevel(ref.read(preferencesRepositoryProvider).level);

              notifier.startGame();
            },
            child: const Text(
              'Pulsa para jugar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _sendPadInfo(TapDownDetails details, Size size) {
    final x = details.localPosition.dx;
    final y = details.localPosition.dy;
    // print('x: $x');
    // print('y: $y');

    final slope = size.height / size.width;
    final aboveMainDiagonal = y < slope * x;
    final aboveSecondaryDiagonal = y < -slope * x + size.height;

    //derecha
    if (aboveMainDiagonal && !aboveSecondaryDiagonal) {
      return 3;
      //arriba
    } else if (aboveMainDiagonal && aboveSecondaryDiagonal) {
      return 0;
      //izquierda
    } else if (!aboveMainDiagonal && aboveSecondaryDiagonal) {
      return 2;
      //abajo
    } else if (!aboveMainDiagonal && !aboveSecondaryDiagonal) {
      return 1;
    }
    return 0;
  }
}

class XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
