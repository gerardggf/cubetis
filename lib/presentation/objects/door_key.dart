import 'dart:async';

import 'package:cubetis/const/const.dart';
import 'package:flutter/material.dart';

class DoorKey extends StatefulWidget {
  const DoorKey({
    super.key,
    this.color = Colors.lightBlueAccent,
    this.seconds = 15,
    this.load = true,
  });

  final Color color;
  final int seconds;
  final bool load;

  @override
  State<DoorKey> createState() => _DoorKeyState();
}

class _DoorKeyState extends State<DoorKey> {
  Timer? timer;
  double value = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.load) {
      value = 1;
      return;
    }
    final percentage = 1 / widget.seconds;
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        if (value >= 1) {
          timer?.cancel();
        }
        value += (percentage / 10);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: CircularProgressIndicator(
              color: widget.color,
              value: 1 - value,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kPadding + 10),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: widget.color,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
