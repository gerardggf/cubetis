import 'package:flutter/material.dart';

class Enemy extends StatelessWidget {
  const Enemy({
    super.key,
    this.color = Colors.red,
    this.enemyIndex,
  });

  final Color color;
  final List<int>? enemyIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //color: color,
            border: enemyIndex != null ? Border.all(width: 1) : null,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.redAccent,
                color,
              ],
            ),
          ),
          child: const Center(
            child: Text("ò_ó"),
          ),
        ),
        if (enemyIndex != null)
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                enemyIndex!.map((e) {
                  if (e == 0) {
                    return 'x';
                  }
                  return e.toString();
                }).join('|'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
