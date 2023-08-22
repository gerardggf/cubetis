import 'package:cubetis/presentation/modules/edit_level/edit_level_controller.dart';
import 'package:cubetis/presentation/modules/levels/levels_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/custom_snack_bar.dart';

class UpdateUserLevelView extends ConsumerStatefulWidget {
  const UpdateUserLevelView({super.key});

  @override
  ConsumerState<UpdateUserLevelView> createState() =>
      _UploadNewLevelViewState();
}

final difficultyLevels = List<int>.generate(101, (index) => index);

class _UploadNewLevelViewState extends ConsumerState<UpdateUserLevelView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final controller = ref.read(editLevelControllerProvider);
        final notifier = ref.read(editLevelControllerProvider.notifier);

        _nameController.text = controller.name;
        notifier.updateDifficulty(controller.difficulty);
      },
    );
  }

  bool isUserLevel = true;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(editLevelControllerProvider);
    final notifier = ref.watch(editLevelControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nivel editado'),
        actions: [
          if (controller.fetching)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!controller.fetching)
            IconButton(
              onPressed: () async {
                if (isUserLevel && controller.name.trim().isEmpty) {
                  showCustomSnackBar(
                    context: context,
                    text: 'El nombre del nivel no puede estar vacío',
                  );
                  return;
                }
                final result =
                    await notifier.updateLevel(isUserLevel: isUserLevel);
                if (!mounted) return;
                if (result) {
                  showCustomSnackBar(
                      context: context, text: 'Se ha actualizado el nivel');
                  context.pop();
                  context.pop();
                } else {
                  showCustomSnackBar(
                    context: context,
                    text: 'Se ha producido un error al actualizar el nivel',
                    color: Colors.red,
                  );
                }
              },
              icon: const Icon(Icons.upload),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(30).copyWith(top: 0),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: '...',
            ),
            onChanged: (value) {
              notifier.updateName(value);
            },
          ),
          const SizedBox(height: 10),
          if (isUserLevel)
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                'Autor: ${controller.authorId}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Dificultad',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Flexible(
                child: DropdownButton<int>(
                  value: controller.difficulty,
                  onChanged: (value) {
                    notifier.updateDifficulty(value ?? 0);
                  },
                  items: [
                    for (var difficultyLevel in difficultyLevels)
                      DropdownMenuItem<int>(
                        value: difficultyLevel,
                        child: Text(
                          difficultyLevel.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Text(
                ' / 100',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          if (ref.read(levelsControllerProvider).isAdmin)
            SwitchListTile(
              title: const Text('Is user level'),
              value: isUserLevel,
              onChanged: (value) {
                setState(
                  () {
                    isUserLevel = value;
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
