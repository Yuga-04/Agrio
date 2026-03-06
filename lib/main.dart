import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:agrio/l10n/app_localizations.dart';

import 'l10n/locale_provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localeNotifier.load();   // restore saved language
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Agrio',
          debugShowCheckedModeBanner: false,

          // ── Localization setup ─────────────────────────────
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('ta'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          initialRoute: '/language',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/language':
                return MaterialPageRoute(
                  builder: (_) => const LanguageSupportScreen(),
                );
              case '/phone':
                return MaterialPageRoute(
                  builder: (_) => const PhoneEntryScreen(),
                );
              case '/otp':
                final args = settings.arguments;
                final phone = args is Map
                    ? (args['phone'] as String? ?? '')
                    : (args is String ? args : '');
                return MaterialPageRoute(
                  builder: (_) => OTPScreen(phoneNumber: phone),
                );
              case '/registration':
                final args = settings.arguments;
                final phone = args is Map
                    ? (args['phone'] as String? ?? '')
                    : (args is String ? args : '');
                return MaterialPageRoute(
                  builder: (_) => RegistrationScreen(phoneNumber: phone),
                );
              case '/home':
                final args = settings.arguments;
                final name = args is Map ? (args['name'] as String? ?? '') : '';
                return MaterialPageRoute(
                  builder: (_) => HomeScreen(userName: name),
                );
              case '/orders':
                return MaterialPageRoute(
                  builder: (_) => const Scaffold(
                    backgroundColor: Colors.white,
                    body: OrderScreen(showBackButton: true),
                  ),
                );
              case '/vani':
                return MaterialPageRoute(
                  builder: (_) => const Scaffold(
                    backgroundColor: Colors.white,
                    body: KisanVaniScreen(),
                  ),
                );
              case '/cart':
                return MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                );
              case '/notification':
                return MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                );
              case '/payment':
                final args = settings.arguments as Map?;
                return MaterialPageRoute(
                  builder: (_) => PaymentScreen(
                    totalAmount: (args?['total'] as int?) ?? 0,
                    itemCount: (args?['itemCount'] as int?) ?? 0,
                    savings: (args?['savings'] as int?) ?? 0,
                  ),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const LanguageSupportScreen(),
                );
            }
          },
        );
      },
    );
  }
}