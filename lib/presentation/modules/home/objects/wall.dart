import 'package:flutter/material.dart';

class Wall extends StatelessWidget {
  const Wall({
    super.key,
    this.isInEnemyPath = false,
    this.color = Colors.blue,
  });
  final Color color;
  final bool isInEnemyPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        padding: const EdgeInsets.all(1.0),
      ),
    );
  }
}
