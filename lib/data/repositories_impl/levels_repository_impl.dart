import 'package:cubetis/data/services/firebase_firestore_service.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/presentation/modules/levels/state/levels_state.dart';

class LevelsRepositoryImpl implements LevelsRepository {
  LevelsRepositoryImpl(
    this.firebaseFirestoreService,
    this.levelsState,
  );

  final FirebaseFirestoreService firebaseFirestoreService;
  final LevelsState levelsState;

  @override
  Future<bool> createLevel(LevelModel level) {
    //para importar niveles de la app de cubets
    // final nivelImportado = xxxxxx;
    // level = LevelModel(
    //   id: xxxxxx,
    //   name: 'xxxxxx',
    //   coinsPos: nivelImportado["monedas"],
    //   enemies: [
    //     EnemyModel(id: 0, enemiesPos: nivelImportado["enemigo"], speed: 1),
    //     if (nivelImportado["enemigo2"] != null &&
    //         (nivelImportado["enemigo2"] as List<dynamic>).isNotEmpty)
    //       EnemyModel(id: 1, enemiesPos: nivelImportado["enemigo2"], speed: 1),
    //   ],
    //   finishPos: nivelImportado["meta"],
    //   playerPos: 111, //((GameParams.rows) * (GameParams.columns - 2)) + 1,
    //   wallsPos: nivelImportado["barreras"],
    //   creationDate: DateTime.now().toString(),
    // );
    final userLevels = levelsState.isUserLevels;
    return firebaseFirestoreService.createLevel(
      level: level,
      userLevels: userLevels,
    );
  }

  @override
  Future<bool> deleteLevel(String id) {
    final userLevels = levelsState.isUserLevels;
    return firebaseFirestoreService.deleteLevel(
      levelId: id,
      userLevels: userLevels,
    );
  }

  @override
  Future<bool> updateLevel({
    required String id,
    required LevelModel level,
  }) {
    final userLevels = levelsState.isUserLevels;
    return firebaseFirestoreService.updateLevel(
      id: id,
      level: level,
      userLevels: userLevels,
    );
  }

  @override
  List<LevelModel> get allLevels => firebaseFirestoreService.allLevels;

  @override
  Future<List<LevelModel>> getLevels() {
    return firebaseFirestoreService.getLevels();
  }

  //user levels --------------------------------------------------

  @override
  Future<LevelModel?> getUserLevel(String id) {
    return firebaseFirestoreService.getUserLevel(id);
  }

  @override
  Stream<List<LevelModel>> subscribeToUserLevels() {
    return firebaseFirestoreService.subscribeToUserLevels();
  }
}
