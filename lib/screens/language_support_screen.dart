import 'package:flutter/material.dart';
import 'package:agrio/l10n/app_localizations.dart';
import 'package:agrio/l10n/locale_provider.dart';

class LanguageSupportScreen extends StatefulWidget {
  const LanguageSupportScreen({super.key});

  @override
  State<LanguageSupportScreen> createState() => _LanguageSupportScreenState();
}

class _LanguageSupportScreenState extends State<LanguageSupportScreen>
    with TickerProviderStateMixin {
  AppLocale? _selected;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  bool _changeOnly = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-select the currently active locale when coming back from drawer
    _selected ??= AppLocale.fromLocale(Localizations.localeOf(context));
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _changeOnly = (args['changeOnly'] as bool?) ?? false;
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selected == null) return;
    localeNotifier.setLocale(_selected!);

    if (_changeOnly) {
      Navigator.pop(context); // just go back — no login flow
    } else {
      Navigator.pushNamed(context, '/phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Read current strings so the screen itself can be translated
    // (useful when coming back via "Change Language" in the drawer)
    final s = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // ── Image section ──
          Flexible(
            flex: 55,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/farmer_holding_phone.png',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.2),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x22000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.white],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content section ──
          Flexible(
            flex: 45,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    8,
                    24,
                    bottomPadding > 0 ? bottomPadding + 8 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        s.selectLanguage,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          height: 1.25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        s.changeLanguageLater,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // ── Language tiles ──
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: AppLocale.all.asMap().entries.map((entry) {
                            final index = entry.key;
                            final lang = entry.value;
                            final isSelected = _selected == lang;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: index < AppLocale.all.length - 1
                                      ? 10
                                      : 0,
                                ),
                                child: _LanguageTile(
                                  locale: lang,
                                  isSelected: isSelected,
                                  onTap: () => setState(() => _selected = lang),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // ── CONTINUE button ──
                      GestureDetector(
                        onTapDown: (_) => _buttonController.forward(),
                        onTapUp: (_) => _buttonController.reverse(),
                        onTapCancel: () => _buttonController.reverse(),
                        onTap: _selected != null ? _onContinue : null,
                        child: ScaleTransition(
                          scale: _buttonScaleAnimation,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _selected != null
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: _selected != null
                                    ? Colors.white
                                    : const Color(0xFFAAAAAA),
                              ),
                              child: Text(s.continueBtn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LANGUAGE TILE
// ─────────────────────────────────────────────
class _LanguageTile extends StatelessWidget {
  final AppLocale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2E7D32).withOpacity(0.07)
              : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF1A1A1A),
              ),
              child: Text(
                locale.native,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: isSelected
                    ? const Color(0xFF2E7D32).withOpacity(0.7)
                    : const Color(0xFF888888),
              ),
              child: Text(
                locale.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
