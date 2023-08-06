import 'package:flutter/material.dart';

class Enemy extends StatelessWidget {
  const Enemy({
    super.key,
    this.color = Colors.red,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
