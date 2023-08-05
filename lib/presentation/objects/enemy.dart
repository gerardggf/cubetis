import 'package:cubetis/const/const.dart';
import 'package:flutter/material.dart';

class Enemy extends StatelessWidget {
  const Enemy({
    super.key,
    this.color = Colors.red,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          transform: Matrix4.rotationZ(20),
          child: Container(
            height: 3,
            color: Colors.grey,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(kPadding + 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //color: color,

            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.redAccent,
                color,
              ],
            ),
          ),
          child: const Center(
            child: Text("ò_ó"),
          ),
        ),
      ],
    );
  }
}
