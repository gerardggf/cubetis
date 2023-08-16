import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/levels_state.dart';

final levelsControllerProvider =
    StateNotifierProvider<LevelsController, LevelsState>(
  (ref) => LevelsController(
    LevelsState(),
  ),
);

class LevelsController extends StateNotifier<LevelsState> {
  LevelsController(
    super.state,
  );

  void updateIsAdmin(bool value) {
    state = state.copyWith(isAdmin: value);
  }
}
