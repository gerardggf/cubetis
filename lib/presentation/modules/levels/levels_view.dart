import 'package:cubetis/presentation/modules/levels/levels_controller.dart';
import 'package:cubetis/presentation/routes/routes.dart';
import 'package:cubetis/presentation/utils/custom_snack_bar.dart';
import 'package:cubetis/presentation/utils/dialogs/show_password_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/levels_grid_widget.dart';
import 'widgets/user_levels_grid_widget.dart';

class LevelsView extends ConsumerStatefulWidget {
  const LevelsView({super.key});

  @override
  ConsumerState<LevelsView> createState() => _LevelsViewState();
}

class _LevelsViewState extends ConsumerState<LevelsView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _tabController.index =
            ref.read(levelsControllerProvider).isUserLevels ? 1 : 0;
        _tabController.addListener(
          () {
            ref
                .read(levelsControllerProvider.notifier)
                .updateIsUserLevels(_tabController.index == 1);
            if (kDebugMode) {
              print(
                ref.read(levelsControllerProvider).isUserLevels
                    ? 'Game levels'
                    : 'User levels',
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(levelsControllerProvider);
    final notifier = ref.watch(levelsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All levels'),
        actions: [
          if (!ref.read(levelsControllerProvider).isUserLevels)
            IconButton(
              padding: const EdgeInsets.all(5),
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
          IconButton(
            onPressed: () {
              context.pushNamed(Routes.info);
            },
            icon: const Icon(
              Icons.info_outline,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(5),
            onPressed: () {
              context.pushNamed(Routes.newLevel);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.now_widgets_outlined),
            ),
            Tab(
              icon: Icon(Icons.people),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LevelsGridWidget(),
          UserLevelsGridWidget(),
        ],
      ),
    );
  }
}
