import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<String> showPasswordDialog({
  required BuildContext context,
  required String title,
}) async {
  String? text;
  return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              obscureText: true,
              onChanged: (value) {
                text = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop(text);
                },
                child: const Text('Confirmar'),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      ) ??
      '';
}
