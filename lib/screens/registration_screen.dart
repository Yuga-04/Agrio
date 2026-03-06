import 'package:flutter/material.dart';
import 'package:agrio/l10n/app_localizations.dart';
import 'package:agrio/l10n/locale_provider.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNumber;
  const RegistrationScreen({super.key, this.phoneNumber = ''});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDistrict;
  String? _selectedBlock;
  String? _selectedVillage;
  String _phoneNumber = '';

  late AnimationController _heroController;
  late AnimationController _cardController;
  late AnimationController _staggerController;
  late AnimationController _buttonController;

  late Animation<double> _heroScale;
  late Animation<double> _heroFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;
  late List<Animation<double>> _fieldFades;
  late List<Animation<Offset>> _fieldSlides;
  late Animation<double> _buttonScale;

  final List<String> _districts = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Tiruchirappalli',
    'Salem',
    'Tirunelveli',
    'Erode',
    'Vellore',
    'Thoothukudi',
    'Dindigul',
  ];
  final List<String> _blocks = [
    'Block 1',
    'Block 2',
    'Block 3',
    'Block 4',
    'Block 5',
  ];
  final List<String> _villages = [
    'Village A',
    'Village B',
    'Village C',
    'Village D',
    'Village E',
  ];

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _selectedDistrict != null &&
      _selectedBlock != null &&
      _selectedVillage != null;

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
      duration: const Duration(milliseconds: 1000),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );

    _heroScale = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );
    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

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

    _fieldFades = List.generate(6, (i) {
      final start = (i * 0.10).clamp(0.0, 0.8);
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });
    _fieldSlides = List.generate(6, (i) {
      final start = (i * 0.10).clamp(0.0, 0.8);
      final end = (start + 0.40).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.35),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _buttonScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _cardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 380), () {
      if (mounted) _staggerController.forward();
    });

    _nameController.addListener(() => setState(() {}));
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

  @override
  void dispose() {
    _heroController.dispose();
    _cardController.dispose();
    _staggerController.dispose();
    _buttonController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;
    final s = AppLocalizations.of(context);
    final langLabel = AppLocale.fromLocale(
      Localizations.localeOf(context),
    ).native;
    final bool canSubmit = _isFormValid;

    // Image takes up ~40% of screen height; card overlaps by 32px
    final double imageHeight = size.height * 0.40;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      // ── KEY FIX: Column inside SingleChildScrollView, not Stack ──────────
      // The card uses Transform.translate(-32px) to overlap the image.
      // Because the card is a normal Column child, SingleChildScrollView
      // can correctly measure its total height and scrolling works.
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero image (bounded — Stack only for overlay widgets) ──────
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Zoomable image
                  FadeTransition(
                    opacity: _heroFade,
                    child: ScaleTransition(
                      scale: _heroScale,
                      child: Image.asset(
                        'assets/farmer_paddy.png',
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.2),
                      ),
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: topPad + 12,
                    left: 16,
                    child: FadeTransition(
                      opacity: _heroFade,
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/otp',
                          arguments: {'phone': _phoneNumber},
                        ),
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
                  // Language chip
                  Positioned(
                    top: topPad + 12,
                    right: 16,
                    child: FadeTransition(
                      opacity: _heroFade,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.language_outlined,
                              size: 15,
                              color: Color(0xFF2E7D32),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              langLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Card: overlaps image by 32px via Transform.translate ──────
            // Transform.translate does NOT affect layout size, so the
            // scrollview still allocates full space — preventing clipping.
            FadeTransition(
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
                    padding: EdgeInsets.fromLTRB(28, 32, 28, botPad + 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Step pill + badge ──
                        _Stagger(
                          fade: _fieldFades[0],
                          slide: _fieldSlides[0],
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
                                      s.step3of3,
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
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.verified_user_outlined,
                                      size: 12,
                                      color: Color(0xFF2E7D32),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      s.newUser,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        _Stagger(
                          fade: _fieldFades[0],
                          slide: _fieldSlides[0],
                          child: Text(
                            s.oneTimeReg,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                              height: 1.15,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        _Stagger(
                          fade: _fieldFades[1],
                          slide: _fieldSlides[1],
                          child: Text(
                            s.fillDetails,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Full Name ──
                        _Stagger(
                          fade: _fieldFades[1],
                          slide: _fieldSlides[1],
                          child: _FieldLabel(label: s.fullName),
                        ),
                        const SizedBox(height: 6),
                        _Stagger(
                          fade: _fieldFades[1],
                          slide: _fieldSlides[1],
                          child: _NameField(
                            controller: _nameController,
                            hint: s.enterFullName,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Mobile ──
                        _Stagger(
                          fade: _fieldFades[2],
                          slide: _fieldSlides[2],
                          child: _FieldLabel(label: s.mobileNumber),
                        ),
                        const SizedBox(height: 6),
                        _Stagger(
                          fade: _fieldFades[2],
                          slide: _fieldSlides[2],
                          child: _LockedPhoneField(
                            phone: _phoneNumber,
                            verifiedLabel: s.verified,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── District ──
                        _Stagger(
                          fade: _fieldFades[3],
                          slide: _fieldSlides[3],
                          child: _FieldLabel(label: s.district),
                        ),
                        const SizedBox(height: 6),
                        _Stagger(
                          fade: _fieldFades[3],
                          slide: _fieldSlides[3],
                          child: _StyledDropdown(
                            hint: s.selectDistrict,
                            icon: Icons.location_city_outlined,
                            value: _selectedDistrict,
                            items: _districts,
                            onChanged: (val) =>
                                setState(() => _selectedDistrict = val),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Block ──
                        _Stagger(
                          fade: _fieldFades[4],
                          slide: _fieldSlides[4],
                          child: _FieldLabel(label: s.block),
                        ),
                        const SizedBox(height: 6),
                        _Stagger(
                          fade: _fieldFades[4],
                          slide: _fieldSlides[4],
                          child: _StyledDropdown(
                            hint: s.selectBlock,
                            icon: Icons.map_outlined,
                            value: _selectedBlock,
                            items: _blocks,
                            onChanged: _selectedDistrict != null
                                ? (val) => setState(() => _selectedBlock = val)
                                : null,
                            disabled: _selectedDistrict == null,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Village ──
                        _Stagger(
                          fade: _fieldFades[5],
                          slide: _fieldSlides[5],
                          child: _FieldLabel(label: s.village),
                        ),
                        const SizedBox(height: 6),
                        _Stagger(
                          fade: _fieldFades[5],
                          slide: _fieldSlides[5],
                          child: _StyledDropdown(
                            hint: s.selectVillage,
                            icon: Icons.holiday_village_outlined,
                            value: _selectedVillage,
                            items: _villages,
                            onChanged: _selectedBlock != null
                                ? (val) =>
                                      setState(() => _selectedVillage = val)
                                : null,
                            disabled: _selectedBlock == null,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Submit ──
                        _Stagger(
                          fade: _fieldFades[5],
                          slide: _fieldSlides[5],
                          child: GestureDetector(
                            onTapDown: (_) => _buttonController.forward(),
                            onTapUp: (_) => _buttonController.reverse(),
                            onTapCancel: () => _buttonController.reverse(),
                            onTap: canSubmit
                                ? () => Navigator.pushNamed(
                                    context,
                                    '/home',
                                    arguments: {
                                      'name': _nameController.text.trim(),
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
                                  color: canSubmit
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: canSubmit
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
                                        color: canSubmit
                                            ? Colors.white
                                            : const Color(0xFFBBBBBB),
                                      ),
                                      child: Text(s.submit),
                                    ),
                                    if (canSubmit) ...[
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
                      ],
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// STAGGER HELPER
// ─────────────────────────────────────────────────────────────────────────────
class _Stagger extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;
  const _Stagger({
    required this.fade,
    required this.slide,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIELD LABEL
// ─────────────────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF555555),
        letterSpacing: 0.4,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAME TEXT FIELD
// ─────────────────────────────────────────────────────────────────────────────
class _NameField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const _NameField({required this.controller, required this.hint});

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final bool filled = widget.controller.text.isNotEmpty;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: _focused
              ? const Color(0xFF2E7D32).withOpacity(0.04)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focused
                ? const Color(0xFF2E7D32)
                : filled
                ? const Color(0xFF2E7D32).withOpacity(0.4)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: Color(0xFFCCCCCC),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              size: 18,
              color: _focused
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFAAAAAA),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOCKED PHONE FIELD
// ─────────────────────────────────────────────────────────────────────────────
class _LockedPhoneField extends StatelessWidget {
  final String phone;
  final String verifiedLabel;
  const _LockedPhoneField({required this.phone, required this.verifiedLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.phone_outlined, size: 18, color: Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              phone,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 11,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(width: 3),
                Text(
                  verifiedLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STYLED DROPDOWN
// ─────────────────────────────────────────────────────────────────────────────
class _StyledDropdown extends StatelessWidget {
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final bool disabled;

  const _StyledDropdown({
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = value != null;
    final Color accent = const Color(0xFF2E7D32);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 54,
      decoration: BoxDecoration(
        color: disabled
            ? const Color(0xFFF0F0F0)
            : selected
            ? accent.withOpacity(0.04)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? accent.withOpacity(0.45) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            icon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: disabled
                    ? const Color(0xFFCCCCCC)
                    : selected
                    ? accent
                    : const Color(0xFFAAAAAA),
                size: 22,
              ),
            ),
            onChanged: disabled ? null : onChanged,
            hint: Row(
              children: [
                const SizedBox(width: 4),
                Icon(
                  icon,
                  size: 18,
                  color: disabled
                      ? const Color(0xFFCCCCCC)
                      : const Color(0xFFAAAAAA),
                ),
                const SizedBox(width: 10),
                Text(
                  hint,
                  style: TextStyle(
                    color: disabled
                        ? const Color(0xFFCCCCCC)
                        : const Color(0xFFBBBBBB),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            selectedItemBuilder: (context) => items
                .map(
                  (item) => Row(
                    children: [
                      const SizedBox(width: 4),
                      Icon(icon, size: 18, color: accent),
                      const SizedBox(width: 10),
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
