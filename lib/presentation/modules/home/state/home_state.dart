import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/const/const.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(false) bool fetching,
    @Default(false) bool isPlaying,
    @Default(0) int points,
    @Default(null) LevelModel? level,
    @Default(defaultPlayerPos) int playerPos,
    @Default([]) List<int> enemiesPos,
  }) = _HomeState;
}
