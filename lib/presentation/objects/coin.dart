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
          borderRadius: BorderRadius.circular(30),
          color: color,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Colors.yellow,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
