import 'package:cubetis/data/repositories_impl/levels_repository_impl.dart';
import 'package:cubetis/data/services/firebase_firestore_service.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelsRepositoryProvider = Provider<LevelsRepository>(
  (ref) => LevelsRepositoryImpl(
    ref.read(firebaseFirestoreServiceProvider),
  ),
);

abstract class LevelsRepository {
  Future<bool> createLevel(LevelModel level);

  Stream<List<LevelModel>> subscribeToLevels();

  Future<List<LevelModel>> getLevels();

  Future<bool> updateLevel({
    required String id,
    required LevelModel level,
  });

  Future<bool> deleteLevel(String id);

  List<LevelModel> get allLevels;
}
