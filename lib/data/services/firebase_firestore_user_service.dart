import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user_model.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../main.dart';

final firebaseFirestoreUserServiceProvider =
    Provider<FirebaseFirestoreUserService>(
  (ref) => FirebaseFirestoreUserService(
    ref.read(firebaseFirestoreProvider),
    ref.read(preferencesRepositoryProvider),
  ),
);

class FirebaseFirestoreUserService {
  FirebaseFirestoreUserService(
    this.firestore,
    this.preferencesRepository,
  );

  final FirebaseFirestore firestore;
  final PreferencesRepository preferencesRepository;

  Future<bool> createFirestoreUser(UserModel? user) async {
    try {
      if (user == null) return false;
      final CollectionReference usersCollection = firestore.collection('users');
      DocumentReference docRef = usersCollection.doc(user.id);
      await docRef.set(
        user.toJson(),
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteFirestoreUser(String userId) async {
    try {
      final CollectionReference usersCollection = firestore.collection('users');
      DocumentReference docRef = usersCollection.doc(userId);
      await docRef.delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> updateFirestoreUsername(String userId, String username) async {
    try {
      final CollectionReference usersCollection = firestore.collection('users');
      DocumentReference docRef = usersCollection.doc(userId);
      await docRef.update(
        {"username": username},
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final CollectionReference usersCollection = firestore.collection('users');
      DocumentReference docRef = usersCollection.doc(userId);
      return await docRef.get().then(
            (event) => UserModel.fromJson(
              event.data() as Map<String, dynamic>,
            ),
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
