import 'package:cubetis/generated/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/modules/home/home_view.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: const ProviderScope(
        overrides: [],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cubetis',
          home: HomeView(),
        ),
      ),
    );
  }
}
