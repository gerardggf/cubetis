import 'package:cubetis/const/const.dart';
import 'package:flutter/material.dart';

class Coin extends StatelessWidget {
  const Coin({
    super.key,
    this.color = Colors.orangeAccent,
    this.secondaryColor = Colors.yellow,
  });

  final Color color, secondaryColor;

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
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: secondaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: secondaryColor,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
