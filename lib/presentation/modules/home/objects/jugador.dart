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
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: color,
        ),
        child: const Center(
          child: Text("0_0"),
        ),
      ),
    );
  }
}
