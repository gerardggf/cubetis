import 'package:flutter/material.dart';

class Door extends StatelessWidget {
  const Door({
    super.key,
    this.color = Colors.lightBlue,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/img/wall.png'),
                opacity: 0.5,
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.color,
                ),
              ),
              borderRadius: BorderRadius.circular(5),
              //color: color,
            ),
            padding: const EdgeInsets.all(1.0),
          ),
        ),
      ],
    );
  }
}
