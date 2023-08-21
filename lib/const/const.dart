import 'package:flutter/material.dart';

class GameParams {
  static const int rows = 13;
  static const int columns = 10;
  static const int lives = 30;

//tiempo movimiento enemigos
  static const int enemyUpdateTime = 300;
  static const int maxEnemies = 50;

  static const int defaultDoorDuration = 10; //in seconds
}

//tamaños por defecto
const double kPadding = 1;
const Color kBackgroundColor = Colors.black;
const double kBtnSize = 60;

//color principal de todo el juego
const Color kColor = Colors.blue;
