import 'package:cubetis/presentation/utils/const.dart';
import 'package:flutter/material.dart';

class Meta extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final vColor;
  // ignore: prefer_typing_uninitialized_variables
  final vChild;

  const Meta({super.key, this.vColor, this.vChild});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: vColor,
              boxShadow: const [
                BoxShadow(color: Colors.white, blurRadius: 1, spreadRadius: 1)
              ]),
          child: Center(child: vChild),
        ));
  }
}
