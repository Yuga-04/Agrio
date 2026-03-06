import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:agrio/l10n/app_localizations.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({super.key, this.phoneNumber = ''});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final ScrollController _scrollController = ScrollController();

  int _resendSeconds = 30;
  bool _canResend = false;
  bool _isComplete = false;
  Timer? _timer;
  String _phoneNumber = '';

  // ── Animation controllers ──────────────────────────────────────────────────
  late AnimationController _heroController; // image entrance
  late AnimationController _cardController; // card rise
  late AnimationController _boxesController; // OTP boxes cascade
  late AnimationController _buttonController; // press scale
  late AnimationController _successController; // verify button pulse

  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;

  // Per-box animations
  final List<Animation<double>> _boxFades = [];
  final List<Animation<Offset>> _boxSlides = [];

  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _boxesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );

    // Hero: slides in from top-left diagonal
    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _heroSlide = Tween<Offset>(begin: const Offset(0, -0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
        );

    // Card: rises from below
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _cardController, curve: Curves.easeOutQuart),
        );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0, 0.45, curve: Curves.easeOut),
      ),
    );

    // Title & subtitle stagger
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _boxesController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _boxesController,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
          ),
        );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _boxesController,
        curve: const Interval(0.08, 0.43, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _boxesController,
            curve: const Interval(0.08, 0.48, curve: Curves.easeOutCubic),
          ),
        );

    // OTP boxes — each cascades in with a delay
    for (int i = 0; i < 4; i++) {
      final start = 0.25 + i * 0.10;
      final end = (start + 0.35).clamp(0.0, 1.0);
      _boxFades.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _boxesController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
      _boxSlides.add(
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _boxesController,
            curve: Interval(start, end + 0.05, curve: Curves.easeOutBack),
          ),
        ),
      );
    }

    _buttonScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Launch sequence
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _cardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 340), () {
      if (mounted) _boxesController.forward();
    });

    _startTimer();

    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(_checkComplete);
    }
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) _scrollToBottom();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _phoneNumber = (args['phone'] as String?) ?? widget.phoneNumber;
    } else {
      _phoneNumber = widget.phoneNumber;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startTimer() {
    _resendSeconds = 30;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  void _checkComplete() {
    final complete = _controllers.every((c) => c.text.isNotEmpty);
    if (complete != _isComplete) setState(() => _isComplete = complete);
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _heroController.dispose();
    _cardController.dispose();
    _boxesController.dispose();
    _buttonController.dispose();
    _successController.dispose();
    _scrollController.dispose();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Stack(
            children: [
              // ── Hero image ────────────────────────────────────────────────
              FadeTransition(
                opacity: _heroFade,
                child: SlideTransition(
                  position: _heroSlide,
                  child: SizedBox(
                    height: size.height * 0.54,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/farmer_spraying.png',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.2),
                    ),
                  ),
                ),
              ),

              // ── Gradient fade ─────────────────────────────────────────────
              Positioned(
                top: size.height * 0.30,
                left: 0,
                right: 0,
                height: size.height * 0.24,
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

              // ── Back button ───────────────────────────────────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: FadeTransition(
                  opacity: _heroFade,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/phone'),
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

              // ── Card ──────────────────────────────────────────────────────
              Positioned(
                top: size.height * 0.42,
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
                            color: Color(0x12000000),
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
                          // Step pill
                          FadeTransition(
                            opacity: _titleFade,
                            child: SlideTransition(
                              position: _titleSlide,
                              child: Container(
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
                                      s.step2of3,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2E7D32),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Title
                          FadeTransition(
                            opacity: _titleFade,
                            child: SlideTransition(
                              position: _titleSlide,
                              child: Text(
                                s.enterOtp,
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

                          // Subtitle
                          FadeTransition(
                            opacity: _subtitleFade,
                            child: SlideTransition(
                              position: _subtitleSlide,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF999999),
                                    height: 1.55,
                                  ),
                                  children: [
                                    TextSpan(text: s.weSent),
                                    TextSpan(
                                      text: _phoneNumber,
                                      style: const TextStyle(
                                        color: Color(0xFF1A1A1A),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),

                          // ── OTP boxes ──────────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (i) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FadeTransition(
                                    opacity: _boxFades[i],
                                    child: SlideTransition(
                                      position: _boxSlides[i],
                                      child: _OTPBox(
                                        controller: _controllers[i],
                                        focusNode: _focusNodes[i],
                                        onChanged: (val) =>
                                            _onOtpChanged(i, val),
                                      ),
                                    ),
                                  ),
                                  if (i < 3) const SizedBox(width: 14),
                                ],
                              );
                            }),
                          ),

                          const SizedBox(height: 20),

                          // Resend row
                          FadeTransition(
                            opacity: _subtitleFade,
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, anim) =>
                                    FadeTransition(
                                      opacity: anim,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.2),
                                          end: Offset.zero,
                                        ).animate(anim),
                                        child: child,
                                      ),
                                    ),
                                child: _canResend
                                    ? GestureDetector(
                                        key: const ValueKey('resend'),
                                        onTap: () {
                                          for (var c in _controllers) {
                                            c.clear();
                                          }
                                          _focusNodes[0].requestFocus();
                                          _startTimer();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF2E7D32,
                                            ).withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            s.resendOtp,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF2E7D32),
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        key: const ValueKey('timer'),
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            size: 14,
                                            color: Color(0xFFBBBBBB),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${s.resendIn}${_resendSeconds}s',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFFAAAAAA),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Verify button ──────────────────────────────────
                          FadeTransition(
                            opacity: _subtitleFade,
                            child: GestureDetector(
                              onTapDown: (_) => _buttonController.forward(),
                              onTapUp: (_) => _buttonController.reverse(),
                              onTapCancel: () => _buttonController.reverse(),
                              onTap: _isComplete
                                  ? () => Navigator.pushNamed(
                                      context,
                                      '/registration',
                                      arguments: {'phone': _phoneNumber},
                                    )
                                  : null,
                              child: ScaleTransition(
                                scale: _buttonScale,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 280),
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: _isComplete
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFEEEEEE),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: _isComplete
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
                                          color: _isComplete
                                              ? Colors.white
                                              : const Color(0xFFBBBBBB),
                                        ),
                                        child: Text(s.verifyOtp),
                                      ),
                                      if (_isComplete) ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.verified_rounded,
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
// OTP BOX — redesigned with larger tap target, cleaner focus states
// ─────────────────────────────────────────────────────────────────────────────
class _OTPBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OTPBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<_OTPBox> createState() => _OTPBoxState();
}

class _OTPBoxState extends State<_OTPBox> with TickerProviderStateMixin {
  bool _isFocused = false;

  // Bounce when digit entered
  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  // Custom blinking cursor
  late AnimationController _cursorController;
  late Animation<double> _cursorOpacity;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _bounceAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );

    // Blinking cursor: repeats on/off every 550ms
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _cursorOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
    _cursorController.repeat(reverse: true);

    widget.focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = widget.focusNode.hasFocus);
    });

    widget.controller.addListener(() {
      if (widget.controller.text.isNotEmpty && mounted) {
        _bounceController.forward().then((_) => _bounceController.reverse());
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool filled = widget.controller.text.isNotEmpty;
    const double boxSize = 62.0;

    return ScaleTransition(
      scale: _bounceAnim,
      child: GestureDetector(
        onTap: () => widget.focusNode.requestFocus(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: filled
                ? const Color(0xFF2E7D32).withOpacity(0.06)
                : _isFocused
                ? const Color(0xFF2E7D32).withOpacity(0.04)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: filled
                  ? const Color(0xFF2E7D32)
                  : _isFocused
                  ? const Color(0xFF2E7D32).withOpacity(0.7)
                  : const Color(0xFFE5E5E5),
              width: filled || _isFocused ? 2.0 : 1.5,
            ),
            boxShadow: (filled || _isFocused)
                ? [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // ── Invisible TextField (captures input only) ──
              Positioned.fill(
                child: Opacity(
                  opacity: 0.0,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    showCursor: false, // we draw our own cursor
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),
              ),

              // ── Digit or blinking cursor ──
              Center(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.controller,
                  builder: (_, value, __) {
                    if (value.text.isNotEmpty) {
                      // Show digit
                      return Text(
                        value.text,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E7D32),
                          height: 1.0,
                        ),
                      );
                    }
                    // Show blinking cursor when focused and empty
                    if (_isFocused) {
                      return AnimatedBuilder(
                        animation: _cursorOpacity,
                        builder: (_, __) => Opacity(
                          opacity: _cursorOpacity.value,
                          child: Container(
                            width: 2,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
