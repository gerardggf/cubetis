import 'package:cubetis/data/services/firebase_firestore_service.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';

class LevelsRepositoryImpl implements LevelsRepository {
  LevelsRepositoryImpl(this.firebaseFirestoreService);

  final FirebaseFirestoreService firebaseFirestoreService;

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
