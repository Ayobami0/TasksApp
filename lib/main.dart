import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/models/database.dart';
import 'package:tasks/providers/brightness.dart';
import 'package:tasks/screens/home.dart';

import 'providers/shared_utility.dart.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseRepository.initDB();

  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final isDark = ref.watch(brightnessProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: !isDark ? Brightness.light : Brightness.dark,
        useMaterial3: true,
        // fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: const HomeScreen(),
    );
  }
}
