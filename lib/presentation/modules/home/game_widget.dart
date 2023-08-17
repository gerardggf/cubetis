import 'package:cubetis/const/const.dart';
import 'package:cubetis/domain/repositories/preferences_repository.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/objects/coin.dart';
import 'package:cubetis/presentation/objects/empty.dart';
import 'package:cubetis/presentation/objects/enemy.dart';
import 'package:cubetis/presentation/objects/finish.dart';
import 'package:cubetis/presentation/objects/player.dart';
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
  final int numCells = GameParams.columns * GameParams.rows;

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
            child: controller.level == null || !controller.isPlaying
                ? Stack(
                    children: [
                      GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: GameParams.columns,
                          ),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: numCells,
                          itemBuilder: (BuildContext context, int index) {
                            return const Empty();
                          }),
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: TextButton(
                          onPressed: () async {
                            await notifier.loadLevel(
                                ref.read(preferencesRepositoryProvider).level);
                            notifier.startGame();
                          },
                          child: const Text(
                            'Start game',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
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
                      } else if (controller.level!.coinsPos.contains(index) &&
                          !controller.points.contains(index)) {
                        return const Coin();
                      } else if (controller.level!.finishPos == index) {
                        return const Finish();
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
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Coin(),
                      ),
                    ),
                    Text(
                      controller.points.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
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
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Player(),
                      ),
                    ),
                    Text(
                      controller.lives.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildButtonControl(HomeController notifier) => Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: Row(
  //               children: [
  //                 const Expanded(
  //                   child: SizedBox(),
  //                 ),
  //                 _buildButtonItem(
  //                   direction: 0,
  //                   iconData: Icons.arrow_drop_up,
  //                 ),
  //                 const Expanded(
  //                   child: SizedBox(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Row(
  //               children: [
  //                 _buildButtonItem(
  //                   direction: 2,
  //                   iconData: Icons.arrow_left,
  //                 ),
  //                 const Expanded(
  //                   child: SizedBox(),
  //                 ),
  //                 _buildButtonItem(
  //                   direction: 3,
  //                   iconData: Icons.arrow_right,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Row(
  //               children: [
  //                 const Expanded(
  //                   child: SizedBox(),
  //                 ),
  //                 _buildButtonItem(
  //                   direction: 1,
  //                   iconData: Icons.arrow_drop_down,
  //                 ),
  //                 const Expanded(
  //                   child: SizedBox(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  // Widget _buildButtonItem({
  //   required int direction,
  //   required IconData iconData,
  // }) {
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () {
  //         final notifier = ref.read(homeControllerProvider.notifier);
  //         notifier.onButtonDown(
  //           direction: direction,
  //           canvasSize: widget.canvasSize,
  //         );
  //       },
  //       child: Container(
  //         width: double.infinity,
  //         height: double.infinity,
  //         decoration: BoxDecoration(
  //           color: kColor,
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Icon(
  //           iconData,
  //           size: kBtnSize,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
