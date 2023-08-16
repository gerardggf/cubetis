import 'package:flutter/material.dart';

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
                  Navigator.pop(context);
                },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
