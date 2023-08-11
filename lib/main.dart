import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubetis/domain/repositories/levels_repository.dart';
import 'package:cubetis/generated/translations.g.dart';
import 'package:cubetis/presentation/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final sharedPreferences = await SharedPreferences.getInstance();
  final friebaseFirestore = FirebaseFirestore.instance;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        firebaseFirestoreProvider.overrideWith((ref) => friebaseFirestore),
      ],
      child: const MyApp(),
    ),
  );
}

final sharedPreferencesProvider = Provider<SharedPreferences>(
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
    ref.read(levelsRepositoryProvider).getLevels();
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
