import 'package:cubetis/data/services/firebase_firestore_service.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';

class LevelsRepositoryImpl implements LevelsRepository {
  LevelsRepositoryImpl(this.firebaseFirestoreService);

  final FirebaseFirestoreService firebaseFirestoreService;

  @override
  Future<bool> createLevel(LevelModel level) {
    return firebaseFirestoreService.createLevel(level);
  }

  @override
  Future<bool> deleteLevel(String id) {
    return firebaseFirestoreService.deleteLevel(id);
  }

  @override
  Stream<List<LevelModel>> subscribeToLevels() {
    return firebaseFirestoreService.subscribeToLevels();
  }

  @override
  Future<bool> updateLevel({required String id, required LevelModel level}) {
    return firebaseFirestoreService.updateLevel(
      id: id,
      level: level,
    );
  }

  @override
  List<LevelModel> get allLevels => firebaseFirestoreService.allLevels;

  @override
  Future<List<LevelModel>> getLevels() {
    return firebaseFirestoreService.getLevels();
  }
}
