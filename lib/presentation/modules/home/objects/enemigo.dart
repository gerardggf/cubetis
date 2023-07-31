import 'package:cubetis/presentation/utils/const.dart';
import 'package:flutter/material.dart';

class Enemigo extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final vColor;
  // ignore: prefer_typing_uninitialized_variables
  final vChild;

  const Enemigo({super.key, this.vColor, this.vChild});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: vColor,
              boxShadow: const [
                BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 1)
              ]),
          child: const Center(child: Text("ò_ó")),
        ));
  }
}
