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
                enemyIndex!.join('|'),
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
