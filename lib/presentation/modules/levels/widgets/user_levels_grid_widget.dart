import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/repositories/levels_repository.dart';
import '../../../routes/routes.dart';
import '../../../utils/dialogs/show_warning_dialog.dart';
import '../../home/home_controller.dart';
import '../levels_controller.dart';

final userlevelsStreamProvider = StreamProvider(
  (ref) => ref.read(levelsRepositoryProvider).subscribeToUserLevels(),
);

class UserLevelsGridWidget extends ConsumerWidget {
  const UserLevelsGridWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(levelsControllerProvider);
    final userLevelsStream = ref.watch(userlevelsStreamProvider);
    return userLevelsStream.when(
      data: (data) {
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: data.length,
          itemBuilder: (_, index) {
            return GestureDetector(
              onLongPress: !controller.isAdmin
                  ? null
                  : () {
                      showCustomWarningDialog(
                        context: context,
                        title: 'Eliminar nivel',
                        content:
                            '¿Estás seguro/a que quieres eliminar este nivel?',
                        onPressedConfirm: () async {
                          await ref.read(levelsRepositoryProvider).deleteLevel(
                              id: data[index].id, isUserLevel: true);
                          if (context.mounted) {
                            context.goNamed(Routes.home);
                          }
                        },
                      );
                    },
              onTap: () async {
                final homeNotifier = ref.read(homeControllerProvider.notifier);
                await homeNotifier.loadUserLevel(data[index].id);
                if (!context.mounted) return;
                context.pop();
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  // border:
                  //     ref.watch(preferencesRepositoryProvider).level == index
                  //         ? Border.all(
                  //             color: Colors.orange,
                  //             strokeAlign: BorderSide.strokeAlignOutside,
                  //             width: 3,
                  //           )
                  //         : null,
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
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          data[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Diff: ${data[index].difficulty}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data[index].authorId,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      error: (error, _) => Center(
        child: Text(
          'Error al cargar los niveles. Error: ${error.toString()}',
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
