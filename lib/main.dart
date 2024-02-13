import 'package:chatpro/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProGemini());
}

class ProGemini extends StatefulWidget {
  const ProGemini({super.key});

  @override
  State<ProGemini> createState() => _ProGeminiState();
}

class _ProGeminiState extends State<ProGemini> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ProGemini",
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
