import 'package:freezed_annotation/freezed_annotation.dart';

part 'levels_state.freezed.dart';

@freezed
class LevelsState with _$LevelsState {
  factory LevelsState({
    @Default(false) bool isPlaying,
    @Default(false) bool isAdmin,
    @Default(false) bool isUserLevels,
    @Default(0) int points,
  }) = _LevelsState;
}
