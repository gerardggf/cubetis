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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
        ),
      ),
    );
  }
}
