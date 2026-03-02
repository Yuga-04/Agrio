import 'package:flutter/material.dart';
import '/screens/language_selection.dart';
import '/screens/phone_entry.dart';
import '/screens/otp_verification.dart';
import '/screens/registration.dart';
import '/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uzhavar App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/language',
      routes: {
        '/language': (context) => const LanguageSelectionScreen(),
        '/phone': (context) => const PhoneEntryScreen(),
        '/otp': (context) => const OTPScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/menu': (context) => const MenuScreen(),
      },
    );
  }
}