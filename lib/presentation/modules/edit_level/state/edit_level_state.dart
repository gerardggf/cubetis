import 'package:cubetis/domain/models/level_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_level_state.freezed.dart';

@freezed
class EditLevelState with _$EditLevelState {
  factory EditLevelState({
    @Default(false) bool fetching,
    @Default('') String name,
    @Default('') String authorId,
    @Default(0) int difficulty,
    @Default(0) int playerPos,
    @Default(0) int objectTypeSelector,
    @Default([]) List<int> wallsPos,
    @Default([]) List<int> coinsPos,
    @Default([]) List<EnemyModel> enemiesPos,
    @Default(null) DoorModel? doors,
    @Default(1) int finishPos,
  }) = _EditLevelState;
}
