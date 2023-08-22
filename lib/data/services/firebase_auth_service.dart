import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/either/either.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../main.dart';
import 'firebase_firestore_service.dart';
import 'firebase_firestore_user_service.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(
    ref.read(firebaseAuthProvider),
    ref.read(firebaseFirestoreServiceProvider),
    ref.read(preferencesRepositoryProvider),
    ref.read(firebaseFirestoreUserServiceProvider),
  ),
);

class FirebaseAuthService {
  FirebaseAuthService(
    this.auth,
    this.firestoreService,
    this.preferencesRepository,
    this.firestoreUserService,
  );

  final FirebaseAuth auth;
  final FirebaseFirestoreService firestoreService;
  final FirebaseFirestoreUserService firestoreUserService;

  final PreferencesRepository preferencesRepository;

  Future<UserModel?> _mapUser(User? user) async {
    if (user == null) {
      return null;
    }
    final firestoreUser = await firestoreUserService.getUser(user.uid);
    return UserModel(
      id: user.uid,
      username: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      creationDate: user.metadata.creationTime.toString(),
      verified: user.emailVerified,
      isAdmin: firestoreUser?.isAdmin ?? false,
    );
  }

  Future<UserModel?> get currentUser async => await _mapUser(auth.currentUser);
  User? get firebaseCurrentUser => auth.currentUser;

  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestoreUserService.createFirestoreUser(
        await _mapUser(credentials.user),
      );
      return 'register-success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<Either<String, UserModel?>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Either.right(
        await _mapUser(credential.user),
      );
    } on FirebaseAuthException catch (e) {
      return Either.left(e.code);
    } catch (e) {
      return Either.left(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification(User user) async {
    return await user.sendEmailVerification();
  }

  Future<void> updateDisplayName(String newUsername) async {
    await firestoreUserService.updateFirestoreUsername(
        firebaseCurrentUser!.uid, newUsername);
    return await firebaseCurrentUser!.updateDisplayName(newUsername);
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }

  Future<void> delete(User user) async {
    await firestoreUserService.deleteFirestoreUser(user.uid);
    return await user.delete();
  }
}
