import 'dart:async';
import 'package:cubetis/presentation/modules/home/game_widget.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/const/const.dart';
import 'package:cubetis/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Size? canvasSize;
  Timer? timer;

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
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(Routes.newLevel);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
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
              : GameWidget(
                  canvasSize: canvasSize,
                ),
    );
  }

  Future<void> startGame() async {
    final controller = ref.read(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);

    notifier.updateIsPlaying(true);

    final enemiesPos =
        controller.level!.enemies.map((e) => e.enemiesPos).toList();

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

        notifier.updateEnemiesPos(currentEnemiesPos);
      },
    );
  }

  void endGame() {
    final notifier = ref.read(homeControllerProvider.notifier);
    notifier.updateIsPlaying(false);
    timer?.cancel();
  }
}
