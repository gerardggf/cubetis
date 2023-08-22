import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/generated/translations.g.dart';
import 'package:cubetis/presentation/routes/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final sharedPreferences = await SharedPreferences.getInstance();
  final friebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        firebaseFirestoreProvider.overrideWith((ref) => friebaseFirestore),
        firebaseAuthProvider.overrideWith((ref) => firebaseAuth),
      ],
      child: const MyApp(),
    ),
  );
}

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => throw UnimplementedError(),
);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => throw UnimplementedError(),
);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with RouterMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(levelsRepositoryProvider).getLevels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Cubetis',
      ),
    );
  }
}
