import 'package:flutter/material.dart';

class Wall extends StatelessWidget {
  const Wall({
    super.key,
    this.isInEnemyPath = false,
    this.enemyIndex,
    //this.color = Colors.blue,
  });
  //final Color color;
  final bool isInEnemyPath;
  final List<int>? enemyIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/img/wall.png'),
                opacity: isInEnemyPath ? 0.6 : 1,
                colorFilter: ColorFilter.mode(
                  isInEnemyPath ? Colors.transparent : Colors.brown,
                  BlendMode.color,
                ),
              ),
              borderRadius: BorderRadius.circular(5),
              //color: color,
            ),
            padding: const EdgeInsets.all(1.0),
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
