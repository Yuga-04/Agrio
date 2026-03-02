import 'package:flutter/material.dart';
import '/screens/language_selection.dart';
import '/screens/phone_entry.dart';
import '/screens/otp_verification.dart';
import '/screens/registration.dart';
import '/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A1A1A),
          elevation: 0,
        ),
      ),
      initialRoute: '/language',
      routes: {
        '/language': (context) => const LanguageSupportScreen(),
        '/phone': (context) => const PhoneEntryScreen(),
        '/otp': (context) => OTPScreen(
              phoneNumber:
                  ModalRoute.of(context)?.settings.arguments as String? ?? '',
            ),
        '/registration': (context) => RegistrationScreen(
              phoneNumber:
                  ModalRoute.of(context)?.settings.arguments as String? ?? '',
            ),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}