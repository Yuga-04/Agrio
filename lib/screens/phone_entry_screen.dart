import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agrio/l10n/app_localizations.dart';

class PhoneEntryScreen extends StatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen>
    with TickerProviderStateMixin {
  bool _agreeToTerms = false;
  final TextEditingController _phoneController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _phoneFocus = FocusNode();
  bool _isFocused = false;
  bool _hasText = false;

  // ── Animation controllers ──────────────────────────────────────────────────
  late AnimationController _heroController; // image zoom-in on load
  late AnimationController _cardController; // card slides up
  late AnimationController _staggerController; // label / hint stagger
  late AnimationController _buttonController; // press scale

  late Animation<double> _heroScale;
  late Animation<double> _heroFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;
  late Animation<double> _label1Fade;
  late Animation<Offset> _label1Slide;
  late Animation<double> _label2Fade;
  late Animation<Offset> _label2Slide;
  late Animation<double> _inputFade;
  late Animation<Offset> _inputSlide;
  late Animation<double> _checkFade;
  late Animation<Offset> _checkSlide;
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
      duration: const Duration(milliseconds: 800),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );

    // Hero: subtle zoom-in + fade
    _heroScale = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );
    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Card: slide up from bottom
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

    // Staggered content inside card
    _label1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _label1Slide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
          ),
        );

    _label2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    _label2Slide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.1, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _inputFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );
    _inputSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.25, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    _checkFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );
    _checkSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.4, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    _buttonScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Stagger launch sequence
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _cardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 380), () {
      if (mounted) _staggerController.forward();
    });

    _phoneController.addListener(() {
      setState(() => _hasText = _phoneController.text.length == 10);
    });

    _phoneFocus.addListener(() {
      setState(() => _isFocused = _phoneFocus.hasFocus);
      if (_phoneFocus.hasFocus) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _cardController.dispose();
    _staggerController.dispose();
    _buttonController.dispose();
    _phoneController.dispose();
    _scrollController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = AppLocalizations.of(context);
    final bool canProceed = _agreeToTerms && _hasText;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Stack(
            children: [
              // ── Full-bleed hero image ──────────────────────────────────────
              FadeTransition(
                opacity: _heroFade,
                child: ScaleTransition(
                  scale: _heroScale,
                  child: SizedBox(
                    height: size.height * 0.56,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/farmer_with_cow.png',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.2),
                    ),
                  ),
                ),
              ),

              // ── Dark gradient over image bottom ───────────────────────────
              Positioned(
                top: size.height * 0.28,
                left: 0,
                right: 0,
                height: size.height * 0.28,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFFFFFFFF)],
                    ),
                  ),
                ),
              ),

              // ── Back button ───────────────────────────────────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: FadeTransition(
                  opacity: _heroFade,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/language'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 17,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Floating card ─────────────────────────────────────────────
              Positioned(
                top: size.height * 0.44,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _cardFade,
                  child: SlideTransition(
                    position: _cardSlide,
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
                      padding: EdgeInsets.fromLTRB(
                        28,
                        32,
                        28,
                        MediaQuery.of(context).padding.bottom + 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Step indicator ──
                          FadeTransition(
                            opacity: _label1Fade,
                            child: SlideTransition(
                              position: _label1Slide,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF2E7D32,
                                      ).withOpacity(0.09),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF2E7D32),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          s.step1of3,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF2E7D32),
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ── Title ──
                          FadeTransition(
                            opacity: _label1Fade,
                            child: SlideTransition(
                              position: _label1Slide,
                              child: Text(
                                s.enterMobile,
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
                            opacity: _label2Fade,
                            child: SlideTransition(
                              position: _label2Slide,
                              child: Text(
                                s.otpSentMsg,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF999999),
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Phone input ──
                          FadeTransition(
                            opacity: _inputFade,
                            child: SlideTransition(
                              position: _inputSlide,
                              child: _PhoneField(
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                isFocused: _isFocused,
                                hasText: _hasText,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Terms checkbox ──
                          FadeTransition(
                            opacity: _checkFade,
                            child: SlideTransition(
                              position: _checkSlide,
                              child: _TermsRow(
                                agreed: _agreeToTerms,
                                onToggle: () => setState(
                                  () => _agreeToTerms = !_agreeToTerms,
                                ),
                                s: s,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── CTA button ──
                          FadeTransition(
                            opacity: _checkFade,
                            child: SlideTransition(
                              position: _checkSlide,
                              child: GestureDetector(
                                onTapDown: (_) => _buttonController.forward(),
                                onTapUp: (_) => _buttonController.reverse(),
                                onTapCancel: () => _buttonController.reverse(),
                                onTap: canProceed
                                    ? () => Navigator.pushNamed(
                                        context,
                                        '/otp',
                                        arguments: {
                                          'phone':
                                              '+91 ${_phoneController.text}',
                                        },
                                      )
                                    : null,
                                child: ScaleTransition(
                                  scale: _buttonScale,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 280),
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: canProceed
                                          ? const Color(0xFF2E7D32)
                                          : const Color(0xFFEEEEEE),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: canProceed
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 280,
                                          ),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                            color: canProceed
                                                ? Colors.white
                                                : const Color(0xFFBBBBBB),
                                          ),
                                          child: Text(s.getOtp),
                                        ),
                                        if (canProceed) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PHONE FIELD
// ─────────────────────────────────────────────────────────────────────────────
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final bool hasText;

  const _PhoneField({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.hasText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: isFocused
            ? const Color(0xFF2E7D32).withOpacity(0.04)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused
              ? const Color(0xFF2E7D32)
              : hasText
              ? const Color(0xFF2E7D32).withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Flag + dial code
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isFocused
                      ? const Color(0xFF2E7D32).withOpacity(0.25)
                      : const Color(0xFFE5E5E5),
                  width: 1,
                ),
              ),
            ),
       child: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Image.asset(
        "assets/india.png",
        width: 24,
        height: 16,
        fit: BoxFit.cover,
      ),
    ),
    const SizedBox(width: 6),
    const Text(
      '+91',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
        letterSpacing: 0.5,
      ),
    ),
  ],
),    ),
          // Number input
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                color: Color(0xFF1A1A1A),
              ),
              decoration: const InputDecoration(
                hintText: '00000 00000',
                hintStyle: TextStyle(
                  color: Color(0xFFCCCCCC),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                counterText: '',
              ),
            ),
          ),
          // Checkmark
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: hasText
                ? Padding(
                    key: const ValueKey('check'),
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  )
                : const SizedBox(key: ValueKey('empty'), width: 16),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TERMS ROW
// ─────────────────────────────────────────────────────────────────────────────
class _TermsRow extends StatelessWidget {
  final bool agreed;
  final VoidCallback onToggle;
  final dynamic s;

  const _TermsRow({
    required this.agreed,
    required this.onToggle,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                color: agreed ? const Color(0xFF2E7D32) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: agreed
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
              ),
              child: agreed
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF777777),
                  height: 1.55,
                ),
                children: [
                  TextSpan(text: s.agreeTerms),
                  TextSpan(
                    text: s.termsLink,
                    style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF2E7D32),
                    ),
                  ),
                  TextSpan(text: s.and),
                  TextSpan(
                    text: s.privacyPolicy,
                    style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INDIAN FLAG
// ─────────────────────────────────────────────────────────────────────────────
class IndianFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        width: 24,
        height: 16,
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFFF9933))),
            Expanded(child: Container(color: Colors.white)),
            Expanded(child: Container(color: const Color(0xFF138808))),
          ],
        ),
      ),
    );
  }
}
