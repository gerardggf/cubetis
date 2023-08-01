import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/home/state/home_state.dart';
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
    if (state.level!.wallsPos.contains(newPos)) {
      return;
    }
    state = state.copyWith(playerPos: newPos);
    print(state.playerPos);
  }

  void updateIsPlaying(bool value) {
    state = state.copyWith(isPlaying: value);
  }

  Future<void> loadLevel(int levelId) async {
    final level = await levelsRepository.getLevel(levelId);
    state = state.copyWith(level: level);
  }
}
