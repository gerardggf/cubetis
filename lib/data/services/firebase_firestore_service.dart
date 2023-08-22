import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubetis/domain/models/level_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

final firebaseFirestoreServiceProvider = Provider<FirebaseFirestoreService>(
  (ref) => FirebaseFirestoreService(
    ref.read(firebaseFirestoreProvider),
  ),
);

class FirebaseFirestoreService {
  FirebaseFirestoreService(this.firestore);

  final FirebaseFirestore firestore;

  List<LevelModel> _allLevels = [];

  Future<bool> createLevel({
    required LevelModel level,
    bool userLevels = true,
  }) async {
    try {
      final collection = firestore.collection(
        userLevels ? 'user_levels' : 'levels',
      );
      DocumentReference docRef = collection.doc();
      final levelWithId = level.copyWith(id: docRef.id);
      await docRef.set(
        levelWithId.toJson(),
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<List<LevelModel>> getLevels() async {
    final collection = firestore.collection('levels');

    final levelsNotMapped = await collection.orderBy('difficulty').get();

    final levels = levelsNotMapped.docs
        .map(
          (doc) => LevelModel.fromJson(
            doc.data(),
          ),
        )
        .toList();
    _allLevels = levels;
    return levels;
  }

  Future<bool> updateLevel({
    required String id,
    required LevelModel level,
    bool userLevels = true,
  }) async {
    try {
      final collection = firestore.collection(
        userLevels ? 'user_levels' : 'levels',
      );
      DocumentReference docRef = collection.doc(id);
      await docRef.update(
        level.toJson(),
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteLevel({
    required String levelId,
    bool userLevels = true,
  }) async {
    try {
      final collection = firestore.collection(
        userLevels ? 'user_levels' : 'levels',
      );
      DocumentReference docRef = collection.doc(levelId);
      await docRef.delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  List<LevelModel> get allLevels => _allLevels;

//user levels ------------------------------------------------------------------------------

  Future<LevelModel?> getUserLevel(String id) async {
    final collection = firestore.collection('user_levels');

    final levelNotMapped = await collection.doc(id).get();

    if (levelNotMapped.data() == null) return null;
    final level = LevelModel.fromJson(
      levelNotMapped.data()!,
    );
    return level;
  }

  Stream<List<LevelModel>> subscribeToUserLevels() async* {
    final collection = firestore.collection('user_levels');
    final levels = collection.orderBy('creationDate').snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => LevelModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );

    yield* levels;
  }
}
