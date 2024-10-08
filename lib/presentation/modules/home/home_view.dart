import 'dart:async';
import 'package:cubetis/presentation/modules/home/game_widget.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/modules/levels/levels_controller.dart';
import 'package:cubetis/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/repositories/preferences_repository.dart';

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
        ref
            .read(homeControllerProvider.notifier)
            .updatePlayerLives(ref.read(preferencesRepositoryProvider).lives);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          controller.level?.name ?? '',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pushNamed(Routes.levels);
          },
          icon: const Icon(Icons.widgets_outlined),
        ),
        actions: [
          if (controller.level != null &&
                  ref.watch(levelsControllerProvider).isAdmin ||
              controller.level?.authorId == 'Prueba')
            IconButton(
              onPressed: () {
                context.pushNamed(
                  Routes.editLevel,
                  pathParameters: {
                    "id": controller.level!.id.toString(),
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          if (ref.watch(levelsControllerProvider).isUserLevels ||
              ref.watch(levelsControllerProvider).isAdmin)
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
          : GameWidget(
              canvasSize: canvasSize,
            ),
    );
  }
}
