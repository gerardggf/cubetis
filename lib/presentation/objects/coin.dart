import 'package:cubetis/const/const.dart';
import 'package:flutter/material.dart';

class Coin extends StatelessWidget {
  const Coin({
    super.key,
    this.color = Colors.yellow,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding + 10),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: color,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
