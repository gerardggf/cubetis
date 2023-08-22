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
  Future<bool> createLevel({
    required LevelModel level,
    bool isUserLevel = true,
  });

  Future<bool> updateLevel({
    required String id,
    required LevelModel level,
    bool isUserLevel = true,
  });

  Future<List<LevelModel>> getLevels();

  Future<bool> deleteLevel({
    required String id,
    bool isUserLevel = true,
  });

  Stream<List<LevelModel>> subscribeToUserLevels();

  Future<LevelModel?> getUserLevel(String id);

  List<LevelModel> get allLevels;
}
