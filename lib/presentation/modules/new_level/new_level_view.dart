import 'dart:async';
import 'package:cubetis/presentation/modules/new_level/new_level_controller.dart';
import 'package:cubetis/presentation/modules/new_level/new_level_widget.dart';
import 'package:cubetis/presentation/utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewLevelView extends ConsumerStatefulWidget {
  const NewLevelView({super.key});

  @override
  ConsumerState<NewLevelView> createState() => _NewLevelViewState();
}

class _NewLevelViewState extends ConsumerState<NewLevelView> {
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
    final notifier = ref.watch(newLevelControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'New level',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              notifier.clearAll();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () async {
              final result = await notifier.uploadLevel();
              if (!mounted) return;
              if (result) {
                showCustomSnackBar(
                    context: context,
                    text: 'Se ha subido el nuevo nivel correctamente');
                context.pop();
              } else {
                showCustomSnackBar(
                  context: context,
                  text: 'Se ha producido un error al subir el nuevo nivel',
                  color: Colors.red,
                );
              }
            },
            icon: const Icon(
              Icons.save,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: canvasSize == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : NewLevelWidget(
              canvasSize: canvasSize,
            ),
    );
  }
}
