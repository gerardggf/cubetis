import 'package:cubetis/presentation/utils/const.dart';
import 'package:flutter/material.dart';

class Coin extends StatelessWidget {
  const Coin({
    super.key,
    this.color = Colors.orange,
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
        ),
      ),
    );
  }
}
