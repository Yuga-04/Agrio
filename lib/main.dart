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
      title: 'Agrio',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/language',
      routes: {
        '/language': (context) => const LanguageSelectionScreen(),
        '/phone': (context) => const PhoneEntryScreen(),
        '/otp': (context) => OTPScreen(
          phoneNumber:
              ModalRoute.of(context)?.settings.arguments as String? ?? '',
        ),
        '/registration': (context) => RegistrationScreen(
          phoneNumber:
              ModalRoute.of(context)?.settings.arguments as String? ?? '',
        ),
        '/menu': (context) => const MenuScreen(),
      },
    );
  }
}
