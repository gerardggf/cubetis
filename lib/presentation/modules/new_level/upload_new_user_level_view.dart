import 'package:cubetis/presentation/modules/levels/levels_controller.dart';
import 'package:cubetis/presentation/modules/new_level/new_level_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/custom_snack_bar.dart';

class UploadNewUserLevelView extends ConsumerStatefulWidget {
  const UploadNewUserLevelView({super.key});

  @override
  ConsumerState<UploadNewUserLevelView> createState() =>
      _UploadNewLevelViewState();
}

final difficultyLevels = List<int>.generate(101, (index) => index);

class _UploadNewLevelViewState extends ConsumerState<UploadNewUserLevelView> {
  final TextEditingController _nameController = TextEditingController();

  bool isUserLevel = true;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newLevelControllerProvider);
    final notifier = ref.watch(newLevelControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo nivel'),
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
                final result = await notifier.uploadLevel(
                  isUserLevel: isUserLevel,
                );
                if (!context.mounted) return;
                if (result) {
                  showCustomSnackBar(
                      context: context,
                      text: 'Se ha subido el nuevo nivel correctamente');
                  context.pop();
                  context.pop();
                } else {
                  showCustomSnackBar(
                    context: context,
                    text: 'Se ha producido un error al subir el nuevo nivel',
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
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                'Autor: Prueba',
                style: TextStyle(
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
