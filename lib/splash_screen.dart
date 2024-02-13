import 'package:chatpro/chat_screen.dart';
import 'package:chatpro/global.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
        const Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ChatScreen())));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GlobalTheme().backgroundColor,
      body: Center(
        child: LottieBuilder.asset(
          "assets/splash.json",
          width: size.width * 0.85,
          height: size.width * 0.75,
        ),
      ),
    );
  }
}
