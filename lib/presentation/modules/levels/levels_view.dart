import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LevelsView extends ConsumerWidget {
  const LevelsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All levels'),
      ),
      body: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: ref.watch(levelsRepositoryProvider).allLevels.length,
          itemBuilder: (_, index) {
            final allLevels = ref.watch(levelsRepositoryProvider).allLevels;

            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                final homeNotifier = ref.read(homeControllerProvider.notifier);
                homeNotifier.clearPoints();
                await homeNotifier.loadLevel(index);
                if (!context.mounted) return;
                context.pop();
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Nivel ${allLevels[index].id}'),
                    Text(
                      allLevels[index].name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
