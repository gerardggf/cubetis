import 'dart:async';
import 'package:cubetis/presentation/modules/edit_level/edit_level_controller.dart';
import 'package:cubetis/presentation/modules/edit_level/edit_level_widget.dart';
import 'package:cubetis/presentation/utils/custom_snack_bar.dart';
import 'package:cubetis/presentation/utils/show_warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditLevelView extends ConsumerStatefulWidget {
  const EditLevelView({
    super.key,
    required this.levelId,
  });

  final int levelId;

  @override
  ConsumerState<EditLevelView> createState() => _EditLevelViewState();
}

class _EditLevelViewState extends ConsumerState<EditLevelView> {
  Size? canvasSize;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        canvasSize = MediaQuery.of(context).size;
        await ref
            .read(editLevelControllerProvider.notifier)
            .loadLevelToUpdate(widget.levelId);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(editLevelControllerProvider);

    final notifier = ref.watch(editLevelControllerProvider.notifier);
    return AbsorbPointer(
      absorbing: controller.fetching,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Level ${widget.levelId}',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showCustomWarningDialog(
                  context: context,
                  title: 'Eliminar todos los objetos',
                  content: '¿Quieres eliminar todos los objetos del nivel?',
                  onPressedConfirm: () {
                    context.pop();
                    notifier.clearAll();
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
            if (controller.fetching)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (!controller.fetching)
              IconButton(
                onPressed: () async {
                  final result = await notifier.updateLevel(widget.levelId);
                  if (!mounted) return;
                  if (result) {
                    showCustomSnackBar(
                        context: context,
                        text: 'Se ha actualizado el nivel ${widget.levelId}');
                    context.pop();
                  } else {
                    showCustomSnackBar(
                      context: context,
                      text:
                          'Se ha producido un error al actualizar el nivel ${widget.levelId}',
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
            : EditLevelWidget(
                canvasSize: canvasSize,
              ),
      ),
    );
  }
}
