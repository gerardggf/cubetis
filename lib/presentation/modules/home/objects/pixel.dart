import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final vColor;
  // ignore: prefer_typing_uninitialized_variables
  final vChild;

  const Pixel({super.key, this.vColor, this.vChild});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: vColor,
        ),
        padding: const EdgeInsets.all(1.0),
        child: Center(child: vChild),
      ),
    );
  }
}
