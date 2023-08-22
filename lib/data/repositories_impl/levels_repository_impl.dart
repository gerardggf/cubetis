import 'package:cubetis/data/services/firebase_firestore_service.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';

class LevelsRepositoryImpl implements LevelsRepository {
  LevelsRepositoryImpl(
    this.firebaseFirestoreService,
  );

  final FirebaseFirestoreService firebaseFirestoreService;
  @override
  Future<bool> createLevel({
    required LevelModel level,
    bool isUserLevel = true,
  }) {
    return firebaseFirestoreService.createLevel(
      level: level,
      userLevels: isUserLevel,
    );
  }

  @override
  Future<bool> deleteLevel({
    required String id,
    bool isUserLevel = true,
  }) {
    return firebaseFirestoreService.deleteLevel(
      levelId: id,
      userLevels: isUserLevel,
    );
  }

  @override
  Future<bool> updateLevel({
    required String id,
    required LevelModel level,
    bool isUserLevel = true,
  }) {
    return firebaseFirestoreService.updateLevel(
      id: id,
      level: level,
      userLevels: isUserLevel,
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