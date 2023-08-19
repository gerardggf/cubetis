import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/const/const.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(false) bool fetching,
    @Default(false) bool isPlaying,
    @Default([]) List<int> points,
    @Default(null) LevelModel? level,
    @Default(0) int playerPos,
    @Default(0) int gameTimerInSeconds,
    @Default([]) List<int> enemiesPos,
    @Default(false) bool doorsOpen,
    @Default(GameParams.lives) int lives,
  }) = _HomeState;
}
