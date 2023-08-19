import 'package:cubetis/const/const.dart';
import 'package:flutter/material.dart';

class Finish extends StatelessWidget {
  const Finish({
    super.key,
    this.color = Colors.white,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Colors.lightBlueAccent,
          //     Colors.white,
          //     Colors.white,
          //     Colors.lightBlueAccent,
          //   ],
          // ),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: color,
            ),
          ],
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
