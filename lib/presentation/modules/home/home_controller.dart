import 'package:cubetis/presentation/modules/home/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(
    HomeState(),
  ),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController(super.state);
}
