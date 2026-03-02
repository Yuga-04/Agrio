import 'package:flutter/material.dart';
import 'screens/language_support_screen.dart';
import 'screens/phone_entry_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uzhavar',
      debugShowCheckedModeBanner: false,
      initialRoute: '/language',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/language':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LanguageSupportScreen(),
            );

          // FIX: PhoneEntryScreen accepts two possible arg shapes:
          //   1. Map<String,String> with key 'code' → language map passed directly
          //      from LanguageSupportScreen (forward navigation).
          //   2. Map with keys 'phone' and 'language' → wrapped map passed from
          //      OTPScreen (back navigation).
          // PhoneEntryScreen.didChangeDependencies() handles both cases.
          case '/phone':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const PhoneEntryScreen(),
            );

          case '/otp':
            final args = settings.arguments;
            String phone = '';
            if (args is Map) {
              phone = (args['phone'] as String?) ?? '';
            } else if (args is String) {
              phone = args;
            }
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => OTPScreen(phoneNumber: phone),
            );

          case '/registration':
            final args = settings.arguments;
            String phone = '';
            if (args is Map) {
              phone = (args['phone'] as String?) ?? '';
            } else if (args is String) {
              phone = args;
            }
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => RegistrationScreen(phoneNumber: phone),
            );

          default:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LanguageSupportScreen(),
            );
        }
      },
    );
  }
}