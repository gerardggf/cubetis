import 'dart:async';
import 'package:cubetis/presentation/modules/home/game_widget.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Nivel ${controller.level?.id ?? '0'}',
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
          icon: const Icon(Icons.menu),
        ),
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
          : GameWidget(
              canvasSize: canvasSize,
            ),
    );
  }
}
