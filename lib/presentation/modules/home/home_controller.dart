import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/home/state/home_state.dart';
import 'package:cubetis/presentation/utils/const.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(
    HomeState(),
    ref.read(levelsRepositoryProvider),
  ),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController(
    super.state,
    this.levelsRepository,
  );

  final LevelsRepository levelsRepository;

  void updatePlayerPos(int newPos) {
    if (state.level!.wallsPos.contains(newPos) ||
        newPos < 0 ||
        newPos >= kRows * kColumns) {
      return;
    }

    if (newPos % kColumns == 0 && newPos > state.playerPos) {
      newPos -= kColumns;
    }
    if ((newPos + 1) % kColumns == 0 && newPos < state.playerPos) {
      newPos += kColumns;
    }
    state = state.copyWith(playerPos: newPos);
  }

  void updateEnemiesPos(List<int> enemiesPos) {
    state = state.copyWith(enemiesPos: enemiesPos);
  }

  void updateIsPlaying(bool value) {
    state = state.copyWith(isPlaying: value);
  }

  Future<void> loadLevel(int levelId) async {
    final level = await levelsRepository.getLevel(levelId);
    state = state.copyWith(level: level);
    print(level.id);
  }
}
