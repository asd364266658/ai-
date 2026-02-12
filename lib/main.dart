import 'package:flutter/material.dart';
import 'package:vivo_ai_writer/screens/home_screen.dart';

void main() {
  runApp(const VivoAIWriterApp());
}

class VivoAIWriterApp extends StatelessWidget {
  const VivoAIWriterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vivoAI写作助手',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF415FFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'VivoSans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF415FFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}