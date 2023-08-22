import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/repositories/levels_repository.dart';
import '../../../../domain/repositories/preferences_repository.dart';
import '../../../routes/routes.dart';
import '../../../utils/dialogs/show_warning_dialog.dart';
import '../../home/home_controller.dart';
import '../levels_controller.dart';

class LevelsGridWidget extends ConsumerWidget {
  const LevelsGridWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(levelsControllerProvider);
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount:
          //!controller.isAdmin ? ref.watch(preferencesRepositoryProvider).maxLevel + 1 :
          ref.watch(levelsRepositoryProvider).allLevels.length,
      itemBuilder: (_, index) {
        final allLevels = ref.watch(levelsRepositoryProvider).allLevels;

        return GestureDetector(
          onLongPress: !controller.isAdmin
              ? null
              : () {
                  showCustomWarningDialog(
                    context: context,
                    title: 'Eliminar nivel',
                    content: '¿Estás seguro/a que quieres eliminar el nivel?',
                    onPressedConfirm: () async {
                      await ref.read(levelsRepositoryProvider).deleteLevel(
                            allLevels[index].id,
                          );
                      await ref.read(levelsRepositoryProvider).getLevels();
                      if (context.mounted) {
                        context.goNamed(Routes.home);
                      }
                      ref
                          .read(homeControllerProvider.notifier)
                          .loadLevel(allLevels.first.id);
                    },
                  );
                },
          onTap: () async {
            final homeNotifier = ref.read(homeControllerProvider.notifier);

            await homeNotifier.loadLevel(allLevels[index].id);
            if (!context.mounted) return;
            context.pop();
          },
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: ref.watch(preferencesRepositoryProvider).levelId ==
                      allLevels[index].id
                  ? Border.all(
                      color: Colors.orange,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: 3,
                    )
                  : null,
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
                  allLevels[index].name,
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
                if (allLevels[index].name.isNotEmpty)
                  Text(
                    allLevels[index].name,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
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
      },
    );
  }
}
