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
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final ScrollController _scrollController = ScrollController();

  int _resendSeconds = 30;
  bool _canResend = false;
  bool _isComplete = false;
  Timer? _timer;

  String _phoneNumber = '';

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _fadeController.forward();
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
    _slideController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    _scrollController.dispose();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardOpen = bottomInset > 0;
    final s = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // ── Image section ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height:
                  keyboardOpen ? size.height * 0.28 : size.height * 0.60,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/farmer_spraying.png',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.2),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: size.height * 0.15,
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
                  Positioned(
                    top: 48,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, '/phone'),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── White card ──
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        s.enterOtp,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          height: 1.25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF888888)),
                          children: [
                            TextSpan(text: s.weSent),
                            TextSpan(
                              text: _phoneNumber,
                              style: const TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // OTP boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: _OTPBox(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              onChanged: (val) => _onOtpChanged(index, val),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 16),

                      // Resend row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _canResend
                                ? GestureDetector(
                                    key: const ValueKey('resend'),
                                    onTap: () {
                                      for (var c in _controllers) c.clear();
                                      _focusNodes[0].requestFocus();
                                      _startTimer();
                                    },
                                    child: Text(
                                      s.resendOtp,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                : Text(
                                    key: const ValueKey('timer'),
                                    '${s.resendIn}${_resendSeconds}s',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // VERIFY button
                      GestureDetector(
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
                          scale: _buttonScaleAnimation,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _isComplete
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
                                color: _isComplete
                                    ? Colors.white
                                    : const Color(0xFFAAAAAA),
                              ),
                              child: Text(s.verifyOtp),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: keyboardOpen ? 16 : 0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OTP BOX
// ─────────────────────────────────────────────
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

class _OTPBoxState extends State<_OTPBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool filled = widget.controller.text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 64,
      height: 60,
      decoration: BoxDecoration(
        color: _isFocused || filled
            ? const Color(0xFFF0F7F0)
            : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isFocused || filled
              ? const Color(0xFF2E7D32)
              : const Color(0xFFDDDDDD),
          width: _isFocused ? 2.0 : 1.5,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 60,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                maxLength: 1,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  color: Colors.transparent,
                  fontSize: 22,
                  height: 1.0,
                ),
                cursorColor: const Color(0xFF2E7D32),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  // contentPadding: EdgeInsets.zero,
                  isDense: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 14), 
                ),
                onChanged: widget.onChanged,
              ),
            ),
            IgnorePointer(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.controller,
                builder: (_, value, __) => Text(
                  value.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}