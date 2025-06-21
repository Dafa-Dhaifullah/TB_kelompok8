import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tb_mobile/home_screen.dart';
import 'package:tb_mobile/providers/auth_provider.dart';
import 'package:tb_mobile/providers/news_provider.dart';
import 'package:tb_mobile/splash_screen.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        
      },
    );
  }
}
