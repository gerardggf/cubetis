import 'package:flutter/material.dart';

const int numFilas = 10;
const int numColumnas = 13;

const int jugadorPosOrigen = ((numFilas) * (numColumnas - 2)) + 1;

//tamaños por defecto
const kPadding = 1.0;
const kPaddingText = 20.0;
const kBackgroundColor = Colors.black;
const kBtnSize = 60.00;
const kFSize = 18.00;
//posición para que no hayan objetos en la matriz (feura del mapa)
const noPos = 130;

//===============================================================================

//color principal de todo el juego
const kColor = Colors.blue;
//(bd 20) maximo de derrotas antes de reiniciar niveles
const vidas = 20;
//tiempo actualización enemigos
const eTime = 250;
//activar números posición en cada cuadrícula
const cuadriculaNums = false;
//(bd 0) nivel máximo guardado en el almacenamiento local (uNivel). Reinicia todos los niveles para que te aparezcan los niveles hasta el indicado
const maxNivelAlcanzado = 1;
