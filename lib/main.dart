import 'package:flutter/material.dart';
import 'screens/language_support_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/phone_entry_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_screen.dart';
import 'screens/kisan_vani_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/payment_screen.dart';

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
      initialRoute: '/language',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/language':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LanguageSupportScreen(),
            );

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

          // HomeScreen receives {name} passed from RegistrationScreen
          case '/home':
            final args = settings.arguments;
            String name = '';
            if (args is Map) {
              name = (args['name'] as String?) ?? '';
            }
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => HomeScreen(userName: name),
            );

          // Standalone Orders screen (deep-link / direct navigation)
          case '/orders':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const Scaffold(
                backgroundColor: Colors.white,
                body: OrderScreen(showBackButton: true),
              ),
            );

          // Standalone Kisan Vani screen (deep-link / direct navigation)
          case '/vani':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const Scaffold(
                backgroundColor: Colors.white,
                body: KisanVaniScreen(),
              ),
            );

          // Cart screen
          case '/cart':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const CartScreen(),
            ); 
            case '/notification':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const NotificationScreen(),
            );

          // Payment screen
          case '/payment':
            final args = settings.arguments as Map?;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => PaymentScreen(
                totalAmount: (args?['total'] as int?) ?? 0,
                itemCount: (args?['itemCount'] as int?) ?? 0,
                savings: (args?['savings'] as int?) ?? 0,
              ),
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