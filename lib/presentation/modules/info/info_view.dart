import 'package:flutter/material.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "¿En qué consiste Cubets?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Ayuda a Cubets, un cuadrado naranja bastante apático, que se ha visto atrapado en un juego para teléfonos móviles. \n\nPara poder escapar tiene que superar todos los niveles, pasando los niveles mediante el portal de color blanco.",
                  ),
                  // Image.asset(
                  //   "assets/img/icono_cubets.png",
                  //   height: 80,
                  //   fit: BoxFit.cover,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Sin embargo, Cubets tiene que haber cogido todas las monedas de cada nivel para poder pasar por dicho portal.",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: const TextSpan(
                      text:
                          "En cada nivel, Cubets se va a encontrar con enemigos, los cuales se tratan de otros Cubets maliciosos que se han quedado atrapados en el juego y ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "siguen siempre el mismo recorrido",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nVe con cuidado, ya que no te lo van a poner fácil. Pueden atravesar las paredes de color azul oscuro, pero tú no.",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Si a Cubets se le agoten las vidas, tendrá que volver a empezar de cero... Mucha suerte.",
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Column(
              children: [
                Text(
                  "¿Cómo se juega?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Puedes controlar a tu jugador mediante los botones de la parte inferior de la pantalla o bien tocando la propia zona de juego tal y como se muestra a continuación.",
                ),
                // Image.asset(
                //   "assets/img/instruc_cubets.png",
                //   height: 400,
                //   fit: BoxFit.cover,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
