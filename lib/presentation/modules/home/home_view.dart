import 'package:cubetis/presentation/modules/home/home_controller.dart';
import 'package:cubetis/presentation/modules/home/objects/enemigo.dart';
import 'package:cubetis/presentation/modules/home/objects/jugador.dart';
import 'package:cubetis/presentation/modules/home/objects/meta.dart';
import 'package:cubetis/presentation/modules/home/objects/moneda.dart';
import 'package:cubetis/presentation/modules/home/objects/pixel.dart';
import 'package:cubetis/presentation/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Size? canvasSize;

  final numPixels = numColumnas * numFilas;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        canvasSize = MediaQuery.of(context).size;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    final notifier = ref.watch(homeControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
          child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: numPixels,
        itemBuilder: (BuildContext context, int index) {
          var indexString = "";
          cuadriculaNums == true
              ? indexString = index.toString()
              : indexString = "";

          //nivel tutorial
          if (nivelLActual == 0 && controller.isPlaying) {
            if (index == 15 || index == 45) {
              indexString = "✖";
            }
            if (index == 41 || index == 71 || index == 103 || index == 106) {
              indexString = "✔";
            }
            if (index == 21) {
              indexString = "${monedasR.toString()}/4";
            }
          }

          //pintar píxeles
          if (jugador == index) {
            return Jugador(
                vColor: Colors.orange,
                vChild: Text(indexString,
                    style: const TextStyle(color: Colors.white)));
          } else if (posEnemigo == index || posEnemigo2 == index) {
            return Enemigo(
                vColor: Colors.red,
                vChild: Text(indexString,
                    style: const TextStyle(color: Colors.white)));
          } else if (nivel.barreras.contains(index) &&
                  nivel.enemigo.contains(index) ||
              nivel.barreras.contains(index) &&
                  nivel.enemigo2.contains(index)) {
            return Pixel(
                vColor: kColor.withOpacity(0.5),
                vChild: Text(indexString,
                    style: const TextStyle(color: Colors.white, fontSize: 10)));
          } else if (nivel.barreras.contains(index)) {
            return Pixel(
                vColor: kColor,
                vChild: Text(indexString,
                    style: const TextStyle(color: Colors.white, fontSize: 10)));
          } else if (nivel.monedas.contains(index)) {
            return Moneda(
                vColor: Colors.yellow,
                vChild: Text(indexString,
                    style: const TextStyle(color: Colors.white, fontSize: 10)));
          } else if (nivel.meta == index) {
            return Meta(
                vColor: Colors.white,
                vChild: Text(indexString,
                    style: const TextStyle(color: Colors.white, fontSize: 10)));
          } else {
            return (Pixel(
                vColor: kBackgroundColor,
                vChild: Text(indexString,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 14))));
          }
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numFilas),
      )),
    );
  }
}
