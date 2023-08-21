import 'package:cubetis/const/const.dart';
import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Player extends ConsumerWidget {
  const Player({
    super.key,
    this.color = Colors.orange,
  });

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(kPadding),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange,
            color,
          ],
        ),
      ),
      child: Image.asset(
        ref.watch(homeControllerProvider).points.length ==
                ref.watch(homeControllerProvider).level?.coinsPos.length
            ? 'assets/img/cubets_2.png'
            : 'assets/img/cubets.png',
      ),
    );
  }
}
