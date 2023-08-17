import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showCustomWarningDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onPressedConfirm,
  VoidCallback? onPressedCancel,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onPressedConfirm,
            child: const Text('Confirmar'),
          ),
          TextButton(
            onPressed: onPressedCancel ??
                () {
                  context.pop();
                },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
