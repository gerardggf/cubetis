import 'package:cubetis/domain/models/level_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_level_state.freezed.dart';

@freezed
class EditLevelState with _$EditLevelState {
  factory EditLevelState({
    @Default(false) bool fetching,
    @Default('') String name,
    @Default(0) int playerPos,
    @Default(0) int objectTypeSelector,
    @Default([]) List<int> wallsPos,
    @Default([]) List<int> coinsPos,
    @Default([]) List<EnemyModel> enemiesPos,
    @Default(0) int finishPos,
  }) = _EditLevelState;
}
