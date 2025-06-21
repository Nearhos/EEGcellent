import 'package:eegcellent/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 171, 211),
  primary: const Color.fromARGB(255, 96, 171, 211),
  onPrimary: const Color.fromARGB(255, 201, 212, 217),
  primaryContainer: const Color.fromARGB(255, 96, 171, 211),
  onPrimaryContainer: const Color.fromARGB(
    255,
    232,
    237,
    239,
  ),
  surface: const Color.fromARGB(255, 232, 237, 239),
  onSurface: const Color.fromARGB(255, 34, 56, 67),
  surfaceContainer: const Color.fromARGB(255, 55, 90, 108),
  secondary: const Color.fromARGB(255, 53, 118, 150),
  brightness: Brightness.light,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EEGcellent',
      theme: ThemeData(
        colorScheme: colorScheme,
        textTheme: GoogleFonts.firaSansTextTheme().copyWith(
          headlineLarge: GoogleFonts.firaSans().copyWith(
            fontSize: 38.0,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
          headlineMedium: GoogleFonts.firaSans().copyWith(
            fontSize: 34.0,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
          headlineSmall: GoogleFonts.firaSans().copyWith(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
          titleLarge: GoogleFonts.firaSans().copyWith(
            fontSize: 28.0,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.firaSans().copyWith(
            fontSize: 26.0,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: GoogleFonts.firaSans().copyWith(
            fontSize: 24.0,
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: GoogleFonts.firaSans().copyWith(
            fontSize: 22.0,
            color: colorScheme.primary,
          ),
          bodyMedium: GoogleFonts.firaSans().copyWith(
            fontSize: 20.0,
            color: colorScheme.primary,
          ),
          bodySmall: GoogleFonts.firaSans().copyWith(
            fontSize: 18.0,
            color: colorScheme.primary,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
