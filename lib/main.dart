import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbm_tugas_praktikum/screens/login_screen.dart';
import 'theme/sd_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pierre's General Store",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kGreenBtn),
        textTheme: GoogleFonts.vt323TextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: kBgGreen,
      ),
      home: const LoginScreen(),
    );
  }
}
