import 'package:cubetis/presentation/utils/const.dart';
import 'package:flutter/material.dart';

class Moneda extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final vColor;
  // ignore: prefer_typing_uninitialized_variables
  final vChild;

  const Moneda({super.key, this.vColor, this.vChild});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(kPadding + 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: vColor,
              boxShadow: const [
                BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 1)
              ]),
          child: Center(child: vChild),
        ));
  }
}
