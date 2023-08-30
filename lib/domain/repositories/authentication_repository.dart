import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories_impl/authentication_repository_impl.dart';
import '../../data/services/firebase_auth_service.dart';
import '../either/either.dart';
import '../models/user_model.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => AuthenticationRepositoryImpl(
    ref.read(firebaseAuthServiceProvider),
  ),
);

abstract class AuthenticationRepository {
  Future<UserModel?> get currentUser;

  User? get firebaseCurrentUser;

  Future<void> signOut();

  Future<void> deleteAccount();

  Future<Either<String, UserModel?>> signIn({
    required String email,
    required String password,
  });

  Future<String> register({
    required String email,
    required String password,
  });

  Future<void> changePassword(String email);

  Future<void> updateDisplayName(String newUsername);

  Future<void> sendVerifyCurrentUsersEmail();
}
