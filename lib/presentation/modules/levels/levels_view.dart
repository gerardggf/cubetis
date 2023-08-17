import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/domain/repositories/preferences_repository.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/modules/levels/levels_controller.dart';
import 'package:cubetis/presentation/routes/routes.dart';
import 'package:cubetis/presentation/utils/show_warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LevelsView extends ConsumerWidget {
  const LevelsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(levelsControllerProvider);
    final notifier = ref.watch(levelsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All levels'),
        actions: [
          IconButton(
            onPressed: () {
              notifier.updateIsAdmin(!controller.isAdmin);
            },
            icon: Icon(
              Icons.key,
              color: controller.isAdmin ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
      body: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: !controller.isAdmin
              ? ref.watch(preferencesRepositoryProvider).maxLevel + 1
              : ref.watch(levelsRepositoryProvider).allLevels.length,
          itemBuilder: (_, index) {
            final allLevels = ref.watch(levelsRepositoryProvider).allLevels;

            return GestureDetector(
              onLongPress: !controller.isAdmin
                  ? null
                  : () {
                      showCustomWarningDialog(
                        context: context,
                        title: 'Eliminar nivel ${allLevels[index].level}',
                        content:
                            '¿Estás seguro/a que quieres eliminar el nivel ${allLevels[index].level}?',
                        onPressedConfirm: () async {
                          await ref.read(levelsRepositoryProvider).deleteLevel(
                                allLevels[index].id,
                              );
                          await ref.read(levelsRepositoryProvider).getLevels();
                          if (context.mounted) {
                            context.goNamed(Routes.home);
                          }
                        },
                      );
                    },
              onTap: () async {
                final homeNotifier = ref.read(homeControllerProvider.notifier);

                await homeNotifier.loadLevel(allLevels[index].level);
                if (!context.mounted) return;
                context.pop();
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nivel ${allLevels[index].level}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Diff: ${allLevels[index].difficulty.toString()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    // Text(
                    //   allLevels[index].name,
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(3),
                    //   child: GridView.builder(
                    //     gridDelegate:
                    //         const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: GameParams.columns,
                    //     ),
                    //     shrinkWrap: true,
                    //     physics: const BouncingScrollPhysics(),
                    //     itemCount: numCells,
                    //     itemBuilder: (BuildContext context, int cellIndex) {
                    //       if (allLevels[index].wallsPos.contains(cellIndex)) {
                    //         return const Wall();
                    //       }
                    //       return const Empty();
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
