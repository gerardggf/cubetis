import 'package:cubetis/main.dart';
import 'package:cubetis/presentation/modules/edit_level/edit_level_view.dart';
import 'package:cubetis/presentation/modules/edit_level/update_user_level_view.dart';
import 'package:cubetis/presentation/modules/levels/levels_view.dart';
import 'package:cubetis/presentation/modules/new_level/new_level_view.dart';
import 'package:cubetis/presentation/modules/new_level/upload_new_user_level_view.dart';
import 'package:cubetis/presentation/modules/offline/offline_view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../modules/home/home_view.dart';
import '../modules/info/info_view.dart';
import 'routes.dart';

mixin RouterMixin on State<MyApp> {
  final router = GoRouter(
    routes: [
      GoRoute(
        name: Routes.home,
        path: '/',
        builder: (_, __) => const HomeView(),
      ),
      GoRoute(
        name: Routes.levels,
        path: '/levels',
        builder: (_, __) => const LevelsView(),
      ),
      GoRoute(
        name: Routes.newLevel,
        path: '/new-level',
        builder: (_, __) => const NewLevelView(),
      ),
      GoRoute(
        name: Routes.uploadNewLevel,
        path: '/upload-new-level',
        builder: (_, __) => const UploadNewUserLevelView(),
      ),
      GoRoute(
        name: Routes.updateLevel,
        path: '/update-level',
        builder: (_, __) => const UpdateUserLevelView(),
      ),
      GoRoute(
        name: Routes.editLevel,
        path: '/edit-level/:id',
        builder: (_, state) {
          final levelId = state.pathParameters['id'] ?? '';
          return EditLevelView(
            id: levelId,
          );
        },
      ),
      GoRoute(
        name: Routes.offline,
        path: '/offline',
        builder: (_, __) => const OfflineView(),
      ),
      GoRoute(
        name: Routes.info,
        path: '/info',
        builder: (_, __) => const InfoView(),
      ),
    ],
  );
}
