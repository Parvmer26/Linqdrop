import 'package:flutter/material.dart';
import 'package:linqdrop/pages/home_page.dart';
import 'package:linqdrop/pages/splash_screen.dart';
import 'package:linqdrop/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'Linqdrop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true).copyWith(
            textTheme: ThemeData.light().textTheme.apply(fontFamily: 'sofia'),
          ),
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'sofia'),
          ),
          themeMode: themeNotifier.currentTheme,
          home: SplashScreen(),
        );
      },
    );
  }
}
