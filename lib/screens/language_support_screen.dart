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

  late AnimationController _heroController;
  late AnimationController _cardController;
  late AnimationController _staggerController;
  late AnimationController _buttonController;

  late Animation<double> _heroScale;
  late Animation<double> _heroFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _tilesFade;
  late Animation<Offset> _tilesSlide;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );

    // Hero: zoom-in + fade (same as phone/OTP)
    _heroScale = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );
    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Card: rises from below
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _cardController, curve: Curves.easeOutQuart),
        );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Staggered content
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
          ),
        );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.1, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _tilesFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );
    _tilesSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.25, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.45, 0.90, curve: Curves.easeOutCubic),
          ),
        );

    _buttonScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Same staggered launch as phone/OTP screens
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _cardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 380), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selected ??= AppLocale.fromLocale(Localizations.localeOf(context));
  }

  @override
  void dispose() {
    _heroController.dispose();
    _cardController.dispose();
    _staggerController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selected == null) return;
    localeNotifier.setLocale(_selected!);
    Navigator.pushNamed(context, '/phone');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final botPad = MediaQuery.of(context).padding.bottom;
    final s = AppLocalizations.of(context);

    // Same proportions as phone/OTP: ~50% image
    final double imageHeight = size.height * 0.52;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero image (same pattern as phone/OTP screens) ────────────
          SizedBox(
            height: imageHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FadeTransition(
                  opacity: _heroFade,
                  child: ScaleTransition(
                    scale: _heroScale,
                    child: Image.asset(
                      'assets/farmer_holding_phone.png',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Card: overlaps image by 32px via Transform.translate ──────
          Expanded(
            child: FadeTransition(
              opacity: _cardFade,
              child: SlideTransition(
                position: _cardSlide,
                child: Transform.translate(
                  offset: const Offset(0, -32),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 32,
                          offset: Offset(0, -8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(28, 32, 28, botPad + 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title ──
                        FadeTransition(
                          opacity: _titleFade,
                          child: SlideTransition(
                            position: _titleSlide,
                            child: Text(
                              s.selectLanguage,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                                height: 1.15,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ── Subtitle ──
                        FadeTransition(
                          opacity: _subtitleFade,
                          child: SlideTransition(
                            position: _subtitleSlide,
                            child: Text(
                              s.changeLanguageLater,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Language tiles ──
                        FadeTransition(
                          opacity: _tilesFade,
                          child: SlideTransition(
                            position: _tilesSlide,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: AppLocale.all.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final lang = entry.value;
                                  final isSelected = _selected == lang;
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: index < AppLocale.all.length - 1
                                            ? 12
                                            : 0,
                                      ),
                                      child: _LanguageTile(
                                        locale: lang,
                                        isSelected: isSelected,
                                        onTap: () =>
                                            setState(() => _selected = lang),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // ── Continue button ──
                        FadeTransition(
                          opacity: _buttonFade,
                          child: SlideTransition(
                            position: _buttonSlide,
                            child: GestureDetector(
                              onTapDown: (_) => _buttonController.forward(),
                              onTapUp: (_) => _buttonController.reverse(),
                              onTapCancel: () => _buttonController.reverse(),
                              onTap: _selected != null ? _onContinue : null,
                              child: ScaleTransition(
                                scale: _buttonScale,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 280),
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: _selected != null
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFEEEEEE),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: _selected != null
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF2E7D32,
                                              ).withOpacity(0.35),
                                              blurRadius: 18,
                                              offset: const Offset(0, 6),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 280,
                                        ),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                          color: _selected != null
                                              ? Colors.white
                                              : const Color(0xFFBBBBBB),
                                        ),
                                        child: Text(s.continueBtn),
                                      ),
                                      if (_selected != null) ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE TILE — same style as language_change_screen
// ─────────────────────────────────────────────────────────────────────────────
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2E7D32).withOpacity(0.07)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Radio circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 22,
              height: 22,
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
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            // Native name
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
            const SizedBox(height: 3),
            // English name
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
