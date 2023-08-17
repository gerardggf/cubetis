import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/domain/repositories/preferences_repository.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/modules/levels/levels_controller.dart';
import 'package:cubetis/presentation/routes/routes.dart';
import 'package:cubetis/presentation/utils/custom_snack_bar.dart';
import 'package:cubetis/presentation/utils/dialogs/show_password_dialog.dart';
import 'package:cubetis/presentation/utils/dialogs/show_warning_dialog.dart';
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
              context.pushNamed(Routes.info);
            },
            icon: const Icon(
              Icons.info_outline,
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () async {
              if (!controller.isAdmin) {
                final result = await showPasswordDialog(
                  context: context,
                  title: 'Modo Administrador',
                );
                if (result.trim() != 'c1234') {
                  if (context.mounted) {
                    showCustomSnackBar(
                      context: context,
                      text: 'La contraseña es incorrecta',
                      color: Colors.red,
                    );
                  }
                  return;
                }
                notifier.updateIsAdmin(true);
                if (context.mounted) {
                  showCustomSnackBar(
                    context: context,
                    text: 'Modo administrador activado',
                  );
                }
              } else {
                notifier.updateIsAdmin(false);
                if (context.mounted) {
                  showCustomSnackBar(
                    context: context,
                    text: 'Modo administrador desactivado',
                    color: Colors.orange,
                  );
                }
              }
            },
            icon: Icon(
              Icons.key,
              color: controller.isAdmin ? Colors.blue : Colors.grey,
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
                  image: const DecorationImage(
                    image: AssetImage('assets/img/wall.png'),
                    opacity: 0.6,
                    colorFilter: ColorFilter.mode(
                      Colors.brown,
                      BlendMode.color,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nivel ${allLevels[index].level}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Diff: ${allLevels[index].difficulty.toString()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
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
