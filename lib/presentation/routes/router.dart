import 'package:cubetis/main.dart';
import 'package:cubetis/presentation/modules/levels/levels_view.dart';
import 'package:cubetis/presentation/modules/new_level/new_level_view.dart';
import 'package:cubetis/presentation/modules/offline/offline_view.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../modules/home/home_view.dart';
import 'routes.dart';

mixin RouterMixin on State<MyApp> {
  final router = GoRouter(
    routes: [
      // GoRoute(
      //   name: Routes.splash,
      //   path: '/',
      //   builder: (_, __) => const SplashView(),
      // ),
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
        name: Routes.offline,
        path: '/offline',
        builder: (_, __) => const OfflineView(),
      ),
    ],
  );
}
