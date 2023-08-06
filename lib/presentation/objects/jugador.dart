import 'package:cubetis/const/const.dart';
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({
    super.key,
    this.color = Colors.orange,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(kPadding + 2),
      duration: const Duration(seconds: 1),
      curve: Curves.bounceIn,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: color,
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange,
            color,
          ],
        ),
      ),
      child: const Center(
        child: Text("0_0"),
      ),
    );
  }
}
